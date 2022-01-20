Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE7F495313
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377311AbiATRWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377301AbiATRWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:22:14 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8861FC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:22:14 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id n8so13585041wmk.3
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=OQ13qNHO6ujYM7aBE5UDzbBLeGx7felMyN+oE3wHJl0=;
        b=3qdhewOFouKr9dQy896BHfqxCv5hIASXGBWOJn2HhpVPXbcp7agRh5ASSr0PV6/i0t
         NvcH5ISt5UL0yUFRm9vEv/2B7HXKttlpRXzTryn84FU3NszoUQAPUGhQ0vqL6WLcP5rg
         ZUIx2cAWB7aBz4HTXl5zFo3TAxY6Whxws6Q6NkK3hVGrNa2BO7O4pa4xoSPslEPWl9aY
         z2mu48a/ZvjPdAV0COLAEhH1x04ugBAFtfvjizFUgvSgOWnDALuNYIJGcfjLTLdsN6Ff
         lBWc2eDbES40gDbz1k/rcnjKA2P7t6yrtejLDpdMLNndQA7tDdW1x9+MKJx2wkTTGgK7
         omNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=OQ13qNHO6ujYM7aBE5UDzbBLeGx7felMyN+oE3wHJl0=;
        b=7DpDcqLIn3ZlX4wPUcGBaNdE2laZJAvaVYz/CnHPXzjYHk/jcxeYB0NyAVw6TQW6O8
         2/PlPDuU22AZsGowWzZoCotVfLnAVE/TQUX1h0emMhXJ/GTDgL9SeDBoQljD5YPxdD6V
         f9qobfJQpFpawPN3418Bf5H+RrwS1aUI6mzFPAEt0qJVlwdtcnaO4X4iviU9g/rR6aD+
         6RUxvrGRCaLhG5IspuYP4uokrzwg7Bb1nZMupVVOwsJovKYF4/eKHm1LKr48dqR9yBqA
         CONAlU2tLHZ0f+M4zA0RSF9080RNuqgqKKGJ0fNGbbv9IsHjVttvdJBVuujS/kLpr2mM
         FiLQ==
X-Gm-Message-State: AOAM533mf39M0gtdIplmJF9hhFTBU9cYGT65otrTMmP/tO9HdqpjyrVh
        /Km7LKLClkdqZ6TP/xKs7a8zqUG9bpi+X805sP2QYw==
X-Google-Smtp-Source: ABdhPJx8uGVVzIIcvZaX+XWB8zrHWHtx3THPaoXsRs3ba+uy0aU8tfF/aAUJFZjoxvJ2mQohl81xOx9cHSPq6lJ9Eq0=
X-Received: by 2002:a05:6000:2aa:: with SMTP id l10mr38107wry.57.1642699333179;
 Thu, 20 Jan 2022 09:22:13 -0800 (PST)
MIME-Version: 1.0
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Thu, 20 Jan 2022 14:22:02 -0300
Message-ID: <CA+NMeC-xsHvQ5KPybDUV02UW_zyy02k6fQXBy3YOBg8Qnp=LZQ@mail.gmail.com>
Subject: tdc errors
To:     baowen.zheng@corigine.com
Cc:     simon.horman@corigine.com, netdev@vger.kernel.org,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When running these 2 tdc tests:

7d64 Add police action with skip_hw option
3329 Validate flags of the matchall filter with skip_sw and
police action with skip_hw
I get this error:

Bad action type skip_hw
Usage: ... gact <ACTION> [RAND] [INDEX]
Where: ACTION := reclassify | drop | continue | pass | pipe |
goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
RAND := random <RANDTYPE> <ACTION> <VAL>
RANDTYPE := netrand | determ
VAL : = value not exceeding 10000
JUMP_COUNT := Absolute jump from start of action list
INDEX := index value used

I'm building the kernel on net-next.

I'm compiling the latest iproute2 version.

It seems like the problem is that support is lacking for skip_hw
in police action in iproute2.

This is the command that fails in test 7d64:
tc actions add action police rate 1kbit burst 10k index 100 skip_hw

To run this particular test do:
./tdc.py -e 7d64

cheers,
Victor
