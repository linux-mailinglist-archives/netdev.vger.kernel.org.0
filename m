Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BE623C527
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 07:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgHEFiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 01:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgHEFiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 01:38:21 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBEBC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:38:21 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id c6so1220149ilo.13
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 22:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=0fLClip+KwSMYzNtUFt56rdw8mY+oLcq23LLFsVdQjE=;
        b=EkkGG2dUatLid/I5kRuLufqtqPothD1D0rS2h5/bCzF/tTyuOgkbon5RZRzEjLM4Vx
         /CbDstgwPFWvdiRDSVcVIs5/Qed4jn56ni7ZGL6AAa5c2urVMHx+ahvlJh8AmG8Nbj0S
         /QpNjyVUZKaE9R2avNn5x/+oFEQPC8FUPJtBpjjhFr0ujz7OMxg7OcJqV+UlodENxZLl
         rxmU1QrC0CrthFKWefxpDE3KCvMZEDC9h/PCT8c2y11BM9rbAbFlDmYkUNmErNkjE4AN
         6tS8FRl6NFhNR3dLMU2gx5OH7/nVdleHClt5N52/VX3GeN6SJNKB4v9ke4r4YAttD+IZ
         hHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0fLClip+KwSMYzNtUFt56rdw8mY+oLcq23LLFsVdQjE=;
        b=WX8VHFghPk3VnDkA/t6+ZC26TIV2W8VAWHi2f+5EwPfPuUJwOl5Quz4ygYs8ptrNX/
         AfZkMK8reOYuh7HHrOkso3N5z5t3kgXq6ilhV9B4z33Mup9cvPTjdK26Zj1FXk87byiG
         eZuYccaB0b5tuMlu7S/t7omp90gHC/NgNAcovlN/VIGPFhd3CrCiEc/1FhJIdBrHz8dv
         N6n8NcJo9rTT5kNlZtKm5IzGVm5qBCSOjH/SgTqihel3ihe9hxtiD79iba95QStrEo0K
         F7ihtkDaPHNxRSLxaKb+aitpJb08PYECfrZHnniEJyiqm6/XRlTTHmt4WWr0MoHTDknh
         Ss5A==
X-Gm-Message-State: AOAM532AKKli1k09zY3tCnGhxmT7phxULrRtYs2P0gRuzaer2WqU89fR
        6RPJah+F6ShusbzSmWnQ2xr9eauOgZ5SlAUC9FAM1q6R
X-Google-Smtp-Source: ABdhPJyudm/sPW/gbN4bPpxjsmQdYkMCXR4xdd0YXYOouFMPqTFFBinNOGY7nkvS5npxfNrDxLj2NBELd60SF7a8jI8=
X-Received: by 2002:a92:9f9a:: with SMTP id z26mr2130069ilk.277.1596605900073;
 Tue, 04 Aug 2020 22:38:20 -0700 (PDT)
MIME-Version: 1.0
From:   satish dhote <sdhote926@gmail.com>
Date:   Wed, 5 Aug 2020 11:08:08 +0530
Message-ID: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
Subject: Question about TC filter
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Team,

I have a question regarding tc filter behavior. I tried to look
for the answer over the web and netdev FAQ but didn't get the
answer. Hence I'm looking for your help.

I added ingress qdisc for interface enp0s25 and then configured the
tc filter as shown below, but after adding filters I realize that
rule is reflected as a result of both ingress and egress filter
command?  Is this the expected behaviour? or a bug? Why should the
same filter be reflected in both ingress and egress path?

I understand that policy is always configured for ingress traffic,
so I believe that filters should not be reflected with egress.
Behaviour is same when I offloaded ovs flow to the tc software
datapath.

Please advise or redirect me to the right channel if this is not
the right place for this question. Below are the executed tc
commands:

tc qdisc add dev enp0s25 ingress

tc -g qdisc show dev enp0s25
qdisc fq_codel 0: root refcnt 2 limit 10240p flows 1024 quantum 1514
target 5.0ms interval 100.0ms memory_limit 32Mb ecn
qdisc ingress ffff: parent ffff:fff1 ----------------

tc filter add dev enp0s25 protocol ip parent ffff: prio 1 flower
dst_ip 192.168.1.1/0.0.0.0 ip_proto tcp skip_hw action drop

tc filter show dev enp0s25 ingress
filter parent ffff: protocol ip pref 1 flower chain 0
filter parent ffff: protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  ip_proto tcp
  skip_hw
  not_in_hw
action order 1: gact action drop
random type none pass val 0
index 1 ref 1 bind 1

tc filter show dev enp0s25 egress   (Shows duplicate flows as above)
filter parent ffff: protocol ip pref 1 flower chain 0
filter parent ffff: protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  ip_proto tcp
  skip_hw
  not_in_hw
action order 1: gact action drop
random type none pass val 0
index 1 ref 1 bind 1

Thanks
Satish
