Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EE3631208
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 01:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKTA13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 19:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKTA11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 19:27:27 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192AB1C3
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 16:27:25 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E2AEB5C0097;
        Sat, 19 Nov 2022 19:27:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 19 Nov 2022 19:27:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=cc:cc:content-transfer-encoding:content-type
        :date:date:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1668904041; x=1668990441; bh=e/7GNaxrH8Nm27LKyActcw0R0
        3UYnuC0GVXu6vYwVBM=; b=tc9bWcBfcVwRwSnMFyQF4DzPtq6AJFHGxF1UC5Ax7
        lENVUw/s6Fd+wB186xVqy3TgMU0ItPzvCudyLjXC39xoMi1fTinOV85yEr3FOT8T
        GvU57a1NOVHxopvDZ7ihh7+d5P+XaV7AS8W8NjqJM3SDZYYmVhH6sQJZornvhrw9
        q7jmVb6Mp1w3F8Vsk6z2RacS2ytkWddhPYX+Ew/xHkRvuH0a8tso9iEnkfFOhEgg
        rIKhqbZOjQ5Q13OgTjW+BGQaOxsK1k+/Ji5nQHv5cr5ezD5EHCPVriMWJEdeITef
        X3KxAJlL/jFG1TXSyDfcgFhKnywApjtDI/bukBCnJwM+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1668904041; x=
        1668990441; bh=e/7GNaxrH8Nm27LKyActcw0R03UYnuC0GVXu6vYwVBM=; b=J
        3WyYFOaCfjlpDwmOGK7rcl2JLWWYLFlFJ9AJYpl7s6SXHsbOMmKCSzw+JBSYfLBC
        OFKT0CbyTQ/k8hcsfE9EdEQz/HqPfhcu5bYVOUEAUilIPNvO6wUewhypN9kKXXgu
        do4T0nAQCn+zDw3XX01XJVLHBmKNtr7+bpMFJ+HGrjq1JpQvYAknDgAkRrBzzIO3
        MOgr/j611c7lrdKovkTldbOukajk6r24qnfoMF766eAMP5ZMf909farAplqlez7R
        gTixfoJzngaOBYTvArmSOGMNCApfJMKMuQta8jY+0R/gJyICFr1sdW2noPXRKoAQ
        UloWS3vFssuS5w6ZSgRIA==
X-ME-Sender: <xms:aXR5Y8tbJoqNs4JPtbLgP8CM6phIf1xQpWsi6_gClkLXBIWvWfWDRw>
    <xme:aXR5Y5eT5zkTZjnyQPQ_86xouK1jtj1TxgY2gRa9OVzyTDfKiECGuK7zXReR1vxmi
    7oOoWPCFRR1JKo1rg>
X-ME-Received: <xmr:aXR5Y3zZx66L_QYDIOZKSthLkroUqsJrIJRhhXmJlwJm9u-u2RVIayqI8rbPublTBzDWQjIqOoPfH39sX39oJWthI5cQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheefgddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefufggjfhfkgggtgfesthhqmhdttderjeenucfhrhhomhepufgrmhcu
    ofgvnhguohiirgdqlfhonhgrshcuoehsrghmsehmvghnughoiigrjhhonhgrshdrtghomh
    eqnecuggftrfgrthhtvghrnhepheduveffueeifeffheetkeefkeelvdfhheetjeeggeeg
    tdfhvdekteelvefhleeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshgrmhesmhgvnhguohiirghjohhnrghsrdgtohhm
X-ME-Proxy: <xmx:aXR5Y_NtsEPhk9V5spCsivv9ScUmEEjuXisA2k4voo6RhjT06VxKBg>
    <xmx:aXR5Y8_mLqdCsuEYuDqQWTqdoG91Wc3Taxobu0sCQ_MFrGdlBrYhvw>
    <xmx:aXR5Y3XcEBzf4eZGvu190pQZQMWCgRCxj033-yUi1KexXAoqJ2v8Ig>
    <xmx:aXR5Y6kkfjpqWeZtFegkX2gKLjIf7TfCAMlFGIZqdImALyo3R2I6Bg>
Feedback-ID: iab794258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 19 Nov 2022 19:27:20 -0500 (EST)
Date:   Sun, 20 Nov 2022 11:27:14 +1100
From:   Sam Mendoza-Jonas <sam@mendozajonas.com>
To:     Joel Stanley <joel@jms.id.au>, Networking <netdev@vger.kernel.org>
CC:     Kees Cook <keescook@google.com>
Subject: Re: warn in ncsi netlink code
User-Agent: K-9 Mail for Android
In-Reply-To: <CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com>
References: <CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com>
Message-ID: <74BE39CB-E770-4526-9FCD-CC602178E26F@mendozajonas.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On November 17, 2022 3:35:17 PM GMT+11:00, Joel Stanley <joel@jms=2Eid=2Eau=
> wrote:
>next-20221114 running on an ast2600 system produced this:
>
>[   44=2E627332] ------------[ cut here ]------------
>[   44=2E632657] WARNING: CPU: 0 PID: 508 at net/ncsi/ncsi-cmd=2Ec:231
>ncsi_cmd_handler_oem+0xbc/0xd0
>[   44=2E642387] memcpy: detected field-spanning write (size 7) of
>single field "&cmd->mfr_id" at net/ncsi/ncsi-cmd=2Ec:231 (size 4)
>[   44=2E655131] CPU: 0 PID: 508 Comm: ncsi-netlink Not tainted
>6=2E1=2E0-rc5-14066-gefbdad8553d8 #17
>[   44=2E664577] Hardware name: Generic DT based system
>[   44=2E664599]  unwind_backtrace from show_stack+0x18/0x1c
>[   44=2E675801]  show_stack from dump_stack_lvl+0x40/0x4c
>[   44=2E681458]  dump_stack_lvl from __warn+0xb8/0x12c
>[   44=2E686814]  __warn from warn_slowpath_fmt+0x9c/0xd8
>[   44=2E692370]  warn_slowpath_fmt from ncsi_cmd_handler_oem+0xbc/0xd0
>[   44=2E699285]  ncsi_cmd_handler_oem from ncsi_xmit_cmd+0x160/0x29c
>[   44=2E706002]  ncsi_xmit_cmd from ncsi_send_cmd_nl+0x13c/0x1dc
>[   44=2E712337]  ncsi_send_cmd_nl from genl_rcv_msg+0x1d0/0x440
>[   44=2E718579]  genl_rcv_msg from netlink_rcv_skb+0xc0/0x120
>[   44=2E724623]  netlink_rcv_skb from genl_rcv+0x28/0x3c
>[   44=2E730182]  genl_rcv from netlink_unicast+0x208/0x370
>[   44=2E735934]  netlink_unicast from netlink_sendmsg+0x1e4/0x450
>[   44=2E742365]  netlink_sendmsg from ____sys_sendmsg+0x23c/0x2b8
>[   44=2E748799]  ____sys_sendmsg from ___sys_sendmsg+0x9c/0xd0
>[   44=2E754941]  ___sys_sendmsg from sys_sendmsg+0x78/0xbc
>[   44=2E760695]  sys_sendmsg from ret_fast_syscall+0x0/0x54
>[   44=2E766544] Exception stack(0xb57b1fa8 to 0xb57b1ff0)
>[   44=2E772191] 1fa0:                   0244f330 0244f1e0 00000003
>7ee36a60 00000000 00000000
>[   44=2E781328] 1fc0: 0244f330 0244f1e0 76f35c60 00000128 76f91550
>0244f387 0244f387 00498e7c
>[   44=2E790462] 1fe0: 76f35d34 7ee36a10 76f1b510 76bba140
>[   44=2E796186] ---[ end trace 0000000000000000 ]---
>
>The relevant code:
>
>static int ncsi_cmd_handler_oem(struct sk_buff *skb,
>                                struct ncsi_cmd_arg *nca)
>{
>        struct ncsi_cmd_oem_pkt *cmd;
>        unsigned int len;
>        int payload;
>        /* NC-SI spec DSP_0222_1=2E2=2E0, section 8=2E2=2E2=2E2
>         * requires payload to be padded with 0 to
>         * 32-bit boundary before the checksum field=2E
>         * Ensure the padding bytes are accounted for in
>         * skb allocation
>         */
>
>        payload =3D ALIGN(nca->payload, 4);
>        len =3D sizeof(struct ncsi_cmd_pkt_hdr) + 4;
>        len +=3D max(payload, padding_bytes);
>
>        cmd =3D skb_put_zero(skb, len);
>        memcpy(&cmd->mfr_id, nca->data, nca->payload);
>        ncsi_cmd_build_header(&cmd->cmd=2Ecommon, nca);
>
>        return 0;
>}
>
>I think it's copying the command payload to the command packet,
>starting at the offset of mfr_id:
>
>struct ncsi_cmd_oem_pkt {
>        struct ncsi_cmd_pkt_hdr cmd;         /* Command header    */
>        __be32                  mfr_id;      /* Manufacture ID    */
>        unsigned char           data[];      /* OEM Payload Data  */
>};
>
>But I'm not too sure=2E
>
>Cheers,
>
>Joel


While it looks a little gross I'm pretty sure this is the intended behavio=
r for the OEM commands=2E We'll need to massage that into something nicer=
=2E

Thanks!
Sam

