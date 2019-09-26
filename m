Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B444BF9D9
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfIZTKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 15:10:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43314 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbfIZTKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 15:10:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id q17so11910wrx.10
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 12:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fM8ivAq++KlcH+cLKhMzOnR0+tA3JFu1gGPjEiL3YEg=;
        b=BBysdexXARE3/L2riJGLXzSrU7jblnnTvgTOGvh+Zw75GKSubLdNtUnPyj2OSHa1tD
         JRt99BovT+35Pk2PWhbWl2NW38ijAIgGR+S1CEt/vIowDtanzpBVGplsWb56Jiz6okEj
         91OIbYmmBbbss7azAVi/faWKkIhzaPXvHATSyIAbzckRhP6cMDw9UeTvLlEHdZnLt0hF
         5VBlmW1pMEvXU9PoeK7YPVNu2OQpiVP7iQEPBsXe2nh/YMPERTRZLf3EwoH5k5IBK0iE
         V9Yd7LNJsgs3A/MN/79heV9jK3/+TZ1ArY0DOHaM6TSvrkXZaU4/7BFcXngizUPQHbOQ
         Jv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fM8ivAq++KlcH+cLKhMzOnR0+tA3JFu1gGPjEiL3YEg=;
        b=rys0FXej11uDOYCWl5MBzdhrlPi/XdFuhra1rChUb/lUFJn/jINqPgszHzkNJpWTRL
         wlCNayc88IKQgrc8vTF/e/cfvJVSuZqJP2T4Wch6QECWy8Jeprx22cwuBzQoJ3/RDzEB
         4KyqLPH0jvYIgXeQbF5hQgHmpA9em6ae0BzwOYpoTJ/uJ3rx0MQjVNDSjz8F37bZE1zd
         BRPZTX6iEsEi7zvlTBsQjmfMyPkPTW/ZpsSglR5rPCUPQ9WnTNV8bR4dzP3/G17bREtY
         ITj4fSG6mWEbaxKafVNzfa2CPGSWKlE29bhsRKvMRoTq5g81xSo1blH/yvyQM+9EsMwD
         E+cg==
X-Gm-Message-State: APjAAAWGwJYM5hNM/So6/J79JaaqgS7fv7UVbLP3tSIU2SOxpt9qZoZO
        pZ/fzHBH5A3hK5lh9/luqPbgQftCXW8iHB6qzwuY6A==
X-Google-Smtp-Source: APXvYqw+od8Aw7hbzZapBl2tzg560HAqYeFq1m+8gsniFYSZgAv2lC9nFI1DbL2nOK42JiLr5+rpSIkMLMKzWqR24XQ=
X-Received: by 2002:adf:fe4a:: with SMTP id m10mr3573wrs.209.1569525002500;
 Thu, 26 Sep 2019 12:10:02 -0700 (PDT)
MIME-Version: 1.0
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 26 Sep 2019 15:09:26 -0400
Message-ID: <CACSApvZtHJNXu4nAWSekJWE3ZxTtfTiLgtQ+=ASNZOYwOgSnHw@mail.gmail.com>
Subject: Introducing Transperf
To:     Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'd like to announce the availability of transperf: a network
protocol performance testing tool.

transperf enables users to test TCP performance over a variety of
emulated network scenarios (using netem), including RTT, bottleneck
bandwidth, and policed rate that can change over time. The tool
supports testing multiple flows on multiple machines, and can test the
coexistence of multiple congestion control algorithms in a single
test. Users can specify test configurations and make assertions about
the expected results (i.e., goodput, RTTs, retransmit rates, and
fairness) using a Python-based configuration language.

The BBR team at Google has been using transperf for some of our BBR
testing, and many of the pastel bandwidth plots from various BBR IETF
slide decks were produced using this tool. Transperf includes support
for plotting internal state used by the BBRv2 algorithm, and can be
easily extended to support other congestion control algorithms as
well. We have found it useful, and hope others find it useful as well.

The code is released under the Apache-2.0 license, and available in a
git repository at:

  https://github.com/google/transperf

The source for transperf is in the git repository, along with example
configuration scripts. It has been tested on Debian 9. We would love
to accept your bug reports, patches, and contributions through GitHub
issues and pull requests.

Co-authored-by: Soheil Yeganeh
Co-authored-by: Arjun Roy
Co-authored-by: Neal Cardwell
Co-authored-by: Luke Hsiao
Co-authored-by: Priyaranjan Jha
Co-authored-by: Haitao Wu
Co-authored-by: Yousuk Seung
Co-authored-by: Kevin(Yudong) Yang
Co-authored-by: Michael McLennan
Co-authored-by: Yuchung Cheng
Co-authored-by: Eric Dumazet
Co-authored-by: Maciej =C5=BBenczykowski
