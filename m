Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F173186E
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 01:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfEaXvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 19:51:10 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33789 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfEaXvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 19:51:10 -0400
Received: by mail-lf1-f66.google.com with SMTP id y17so9256941lfe.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 16:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiWUvBY7somdxXm4Nm9ofZYlJeQ87P/U1nz83E0igJ8=;
        b=Dne96kAmvFl3keq6Ga97yT2Djm8eDoMJIPD1E5N8AKsWvZm3KDDB6EQeHKi/6uPIDU
         8gM5+xbzV1B+RW6oPkvtFZQXxAkk+wQEIJFQoqZJJnYnGI0GEHMSd23zbQcrsehys+0d
         VfrGPkwVGActedAKctXXMs7gUOIy5PtlrkMOUTrbfI8vXG0yN+2hZTjkAsK+botiUZYY
         OSQcxB0ZmjwJYxidpamkkHbacP42s7NxSv026xfs7EwGUCOVG23X2VChRgtWVpJA71Eh
         Ss5lD6aRNbQHtxN8OjN7O0H5poIlH5iRIFKd8tpx8GZTD8w/vpKLSXKqt4IdkO+wmj7c
         K8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiWUvBY7somdxXm4Nm9ofZYlJeQ87P/U1nz83E0igJ8=;
        b=kPrPshocjtyFQYIzs5jEPNHpo9blvCnxrOVv0A7Y+k6awmQyvjODj7ZQOOG1TBATkL
         W9cigz2CTOLPxmT2cpcboPOhSUMmneC+FxcBYnkNfXNGC2Vwakc6nZ+Ii8+tClAdS0dV
         wBS0qkJCzPO3pDSH06O7f45jz39xW8WM82H7GbjXhpatKr9c5vow2a5eKYbrV9Qsxqaw
         xaJ2ZcXnRu22Y9PhkxhZ0UG7TkbH3Y1eY+juWT3KDRkDOoF2Joa8BkGDj8LnsHCZGDLc
         2MjlR85ZWaLxl0v88uakFr5PCGQUlqW0hKq9fT2uC9HTyI0EgixgvKZjjU5Uv6kH6q1s
         Xxmg==
X-Gm-Message-State: APjAAAX1NCqRskyHUXvN1axu03q9EbEF0J/eWls0NKfR9CcjMw9yh4lM
        gHfBEcYGleqtVTqVF3VJ219vQyB/UKkdefXurjY=
X-Google-Smtp-Source: APXvYqwjYCWpwWtqVvMZ02KJC9pYgDCBGYhIo5TPGfbeGznaj7EiRuk72arc7vnHeLnlot/3oK3zj1sVHbAuSnNABXU=
X-Received: by 2002:a19:750b:: with SMTP id y11mr7071385lfe.6.1559346668270;
 Fri, 31 May 2019 16:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235940.1452963-1-brakmo@fb.com> <20190531181122.xx5h63bz3t3iwy2l@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190531181122.xx5h63bz3t3iwy2l@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 May 2019 16:50:56 -0700
Message-ID: <CAADnVQKp1E+z-Hh2Tg=4XnSZ_1Zcc0QqRDLCFE5R4kOo2A3eDQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/6] bpf: Propagate cn to TCP
To:     Martin Lau <kafai@fb.com>
Cc:     Lawrence Brakmo <brakmo@fb.com>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 11:13 AM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, May 28, 2019 at 04:59:34PM -0700, brakmo wrote:
> > This patchset adds support for propagating congestion notifications (cn)
> > to TCP from cgroup inet skb egress BPF programs.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
