Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1875FE2BA
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 21:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJMTc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 15:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJMTcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 15:32:24 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FD918024D
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 12:32:23 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-358bf076f1fso26958197b3.9
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 12:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AW8/S8QaaPbDSQmm4+WaEGmXgRTjOSwKzCGRKXSS74M=;
        b=G+/mgBYQ/74kpdLsKSgbFBX+zzTlfIt1b+oQZLUlzTLkxCClviXylPG/8EzLnjcgWJ
         RCYCHxD4jJ4WjPspSViEaMbIDS4REX2OBuHY4sSTazBPuhFMLikmsVDOwZqaxc++8kio
         sxsko9MQKR6pjH0cQHRszW5OSjEmwEorel0ggvvGTtUxYBJsHfJYkWoEHgrXSUrSfwwk
         BAwTYEB4XkvGyqrIx7VkZIGORj3PvPyOWO0/uuPzr8Xr559QT/7HCxc5oq0CrwwiKdzO
         WvYQ40YjRoRYLW2ryvLlX2ONX55eIr4FbKQSIc7eMoIOQPbbcmDP1FzhPnOySipieaon
         gUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AW8/S8QaaPbDSQmm4+WaEGmXgRTjOSwKzCGRKXSS74M=;
        b=eifxT7WxT5YZ2WTETqFFFkZ4pHQtI2bgAb9u2a1sPYXKSx6Kj0znmK+7olBIc1URDO
         c6Dp1IWvJ0Nux7X8HVOIg6/A42WYyWwpr7Dk0FtbpeAERRYq/ZCqmsf7Sxl/JfFevsE4
         gpnoX3+u1VmBsBV+uj0BF1bdiQb3GFYdD/SIZdRLJDBsChKYrPj3Et2TuOeVWxEg9bw3
         0i3K9wAv+yaOKfwZaM98y/db5QHmdUYIRpqLipjR/G2+JycOcga0AZOGbi34rr5pDKal
         fJArDRdyr2e7S/1XgT9tOPa0J8S379/MRDGfmZIP+ZzffYS7q7dsxYJrej41zHqheeD/
         iNwA==
X-Gm-Message-State: ACrzQf34fj2txqrAkbmba55YMi5A4om1REv5qiOAoXc3yJgkCur4tFku
        08+EE9r3/SQqD99UP2uaVtowxXpTXPVoKieV1bGiIRlJfSJzcQ==
X-Google-Smtp-Source: AMsMyM4sL7p3LBsRV7c9IBd7q+QP1e64CjF5QoLm9AbH3zi1JE5aHwiWsvnXGh49qoDw8ni8bWt9ivC7rgdxiA3rI0o=
X-Received: by 2002:a81:12cb:0:b0:35c:b2a7:45f5 with SMTP id
 194-20020a8112cb000000b0035cb2a745f5mr1427737yws.332.1665689542680; Thu, 13
 Oct 2022 12:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <7ca43184bb5b40108b47bfcbffd7adf7@b-ulltech.com>
In-Reply-To: <7ca43184bb5b40108b47bfcbffd7adf7@b-ulltech.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Oct 2022 12:32:11 -0700
Message-ID: <CANn89iLm4zkvS0Yht=MmFfLgY_yodA9DFfuWe7P1YhPMD6mwrg@mail.gmail.com>
Subject: Re: TCP - Receiving unacceptable ACK in ESTABLISHED state
To:     =?UTF-8?B?WWFrdXAgWcSxbGTEsXo=?= <yakup.yildiz@b-ulltech.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 12:10 PM Yakup Y=C4=B1ld=C4=B1z
<yakup.yildiz@b-ulltech.com> wrote:
>
> Hi,
>
> my name is Yakup Erdem Yildiz and I am currently working as an FPGA engin=
eer at Bull Technology in Istanbul. We are working on a hardware TCP implem=
entation and we are using some test scenarios to verify our hardware design=
.
>
> We applied the same scenarios on a Linux machine, which has the kernel re=
lease 5.4.0 and we found out that the Linux TCP does not behave properly in=
 the following case, where "10.10.10.1" is the Linux machine under test.
>
>
>
> According to the RFC 9293, in a synchronized state TCP must send an empty=
 ACK segment upon receiving a segment containing an unacceptable ACK number=
. Here in this case, no ACK is issued after receiving an unacceptable segme=
nt in ESTABLISHED state.
>
>
> -RFC 9293, p. 29
>
>    "If the connection is in a synchronized state (ESTABLISHED, FIN-WAIT-1=
, FIN-WAIT-2, CLOSEWAIT,
>    CLOSING, LAST-ACK, TIME-WAIT), any unacceptable segment (out-of-window
>    sequence number or unacceptable acknowledgment number) must be respond=
ed to with an
>    empty acknowledgment segment (without any user data) containing the cu=
rrent send
>    sequence number and an acknowledgment indicating the next sequence num=
ber expected to
>    be received, and the connection remains in the same state."
>

We do not want to send an ACK for such a probe, coming from an attacker.
If the remote stack is that buggy, sending an ACK will not work around
the bug anyway.

I think the RFC 9293 (and RFC 793 3.9) spirit is to send ACK for old
ACKS, but not for ACK which are coming from the future (or very old
packets)

Also look for RFC 5961 recommendations if you implement a TCP stack.

> We wonder if this is a known issue, or is it an issue at all? We would be=
 thankful if you can inform us about that.
>
> I also added the corresponding capture file as attachment.
>
> Regards,
>
> Yakup Erdem Yildiz
>
>
