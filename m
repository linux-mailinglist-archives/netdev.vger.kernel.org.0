Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0968663687
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 02:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjAJBIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 20:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjAJBIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 20:08:14 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F7CB0E
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 17:08:13 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id bj3so7429275pjb.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 17:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k8AMc80NG2wkXuOd1o8xxMd4VAtWYi94SCUYwGS0CkA=;
        b=fpmrOVO4XK1ASmHzMlmF2XC8imjD72aMBSNgQr08uFW8SFC74n8nA0BOuPr9yNmuBo
         T6aOAhzPIVJ6OegOBwcehlJJYLZsKisac6Ucnk2UV+gmVyDBVysWl6cCcWnn5r9DfI6L
         16sb/wrUuYga9rBcQM2RkHbTpaejPuNwCQepYbJ47nouOXIjHbPmS5x1DRuUfsdUrqI6
         KsM43slQAtnoHE5gbXHknoxJFCV0gBZJAh+1ZXzAQLpDoM1KwL/TpTGLsSJDIoESE/0K
         wVGZq/sgLVzKG33D1U3G1vEP+ABusF2TBjrR7SupruIcsy4BGa072glM26tBAgOp7jWI
         0OXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k8AMc80NG2wkXuOd1o8xxMd4VAtWYi94SCUYwGS0CkA=;
        b=wuUs0k80PrNRXPBa845z7a+sNTM2EgRv9iXeu+f3HyjKpLSehO4G4RnQDCJOE86oaB
         jThVlUtgbsed16aD7h8vpuMP+W9tTt0Yntt5yO7AOqWREN83ZhyA379LBKk7DQVIFQ7C
         0hE2WqbKlbJ4C2DI9hd5pPsgNcpqbdA5Z4cx/1JTB6dDm5vxd+PxZZrZhUhlnpcUtEmw
         h5rPATQMdGrXGwgWXyRbtz7jQsv27z1B5kfY2AdQ5KNpgsC7NAHPVT4SjwwMFakgbxha
         aHjmr7v/Xiv8TbqoVDl62DsbXAboWFH6Xh9ozFq7J3RyIR6z81Q7Oaz0tFGXoA7kphod
         N6pQ==
X-Gm-Message-State: AFqh2kpc/2nyyeJ2XizV62WpUhregfxZhFN6gb2wMmRWbdFgxaAkaBjq
        TxJG9hZEXAvT8X+aRaUiJtA=
X-Google-Smtp-Source: AMrXdXvAdklTm9gCSji5s6NpYs9HSfXlKQG7r0WXtVkxXSYCjCNq8wf6oYuCuJ4KAwPF3N6QxWHLzw==
X-Received: by 2002:a17:90b:1982:b0:225:dd16:ac4c with SMTP id mv2-20020a17090b198200b00225dd16ac4cmr55202635pjb.16.1673312892474;
        Mon, 09 Jan 2023 17:08:12 -0800 (PST)
Received: from [192.168.0.128] ([98.97.43.196])
        by smtp.googlemail.com with ESMTPSA id c10-20020a17090a674a00b002263faf8431sm3860236pjm.17.2023.01.09.17.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 17:08:11 -0800 (PST)
Message-ID: <eb90b5405303b3c8330cd985b77950a6d94f3b85.camel@gmail.com>
Subject: Re: [PATCH net] net/sched: act_mpls: Fix warning during failed
 attribute validation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, willemb@google.com, simon.horman@netronome.com,
        john.hurley@netronome.com, harperchen1110@gmail.com,
        johannes@sipsolutions.net
Date:   Mon, 09 Jan 2023 17:08:10 -0800
In-Reply-To: <20230107171004.608436-1-idosch@nvidia.com>
References: <20230107171004.608436-1-idosch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-01-07 at 19:10 +0200, Ido Schimmel wrote:
> The 'TCA_MPLS_LABEL' attribute is of 'NLA_U32' type, but has a
> validation type of 'NLA_VALIDATE_FUNCTION'. This is an invalid
> combination according to the comment above 'struct nla_policy':
>=20
> "
> Meaning of `validate' field, use via NLA_POLICY_VALIDATE_FN:
>    NLA_BINARY           Validation function called for the attribute.
>    All other            Unused - but note that it's a union
> "
>=20
> This can trigger the warning [1] in nla_get_range_unsigned() when
> validation of the attribute fails. Despite being of 'NLA_U32' type, the
> associated 'min'/'max' fields in the policy are negative as they are
> aliased by the 'validate' field.
>=20
> Fix by changing the attribute type to 'NLA_BINARY' which is consistent
> with the above comment and all other users of NLA_POLICY_VALIDATE_FN().
> As a result, move the length validation to the validation function.
>=20
> No regressions in MPLS tests:
>=20
>  # ./tdc.py -f tc-tests/actions/mpls.json
>  [...]
>  # echo $?
>  0
>=20
> [1]
> WARNING: CPU: 0 PID: 17743 at lib/nlattr.c:118
> nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
> Modules linked in:
> CPU: 0 PID: 17743 Comm: syz-executor.0 Not tainted 6.1.0-rc8 #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> RIP: 0010:nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
> [...]
> Call Trace:
>  <TASK>
>  __netlink_policy_dump_write_attr+0x23d/0x990 net/netlink/policy.c:310
>  netlink_policy_dump_write_attr+0x22/0x30 net/netlink/policy.c:411
>  netlink_ack_tlv_fill net/netlink/af_netlink.c:2454 [inline]
>  netlink_ack+0x546/0x760 net/netlink/af_netlink.c:2506
>  netlink_rcv_skb+0x1b7/0x240 net/netlink/af_netlink.c:2546
>  rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:6109
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  ____sys_sendmsg+0x38f/0x500 net/socket.c:2482
>  ___sys_sendmsg net/socket.c:2536 [inline]
>  __sys_sendmsg+0x197/0x230 net/socket.c:2565
>  __do_sys_sendmsg net/socket.c:2574 [inline]
>  __se_sys_sendmsg net/socket.c:2572 [inline]
>  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2572
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>=20
> Link: https://lore.kernel.org/netdev/CAO4mrfdmjvRUNbDyP0R03_DrD_eFCLCguz6=
OxZ2TYRSv0K9gxA@mail.gmail.com/
> Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> Reported-by: Wei Chen <harperchen1110@gmail.com>
> Tested-by: Wei Chen <harperchen1110@gmail.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/sched/act_mpls.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> index ff47ce4d3968..6b26bdb999d7 100644
> --- a/net/sched/act_mpls.c
> +++ b/net/sched/act_mpls.c
> @@ -134,6 +134,11 @@ static int valid_label(const struct nlattr *attr,
>  {
>  	const u32 *label =3D nla_data(attr);
> =20
> +	if (nla_len(attr) !=3D sizeof(*label)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Invalid MPLS label length");
> +		return -EINVAL;
> +	}
> +
>  	if (*label & ~MPLS_LABEL_MASK || *label =3D=3D MPLS_LABEL_IMPLNULL) {
>  		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
>  		return -EINVAL;
> @@ -145,7 +150,8 @@ static int valid_label(const struct nlattr *attr,
>  static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] =3D {
>  	[TCA_MPLS_PARMS]	=3D NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
>  	[TCA_MPLS_PROTO]	=3D { .type =3D NLA_U16 },
> -	[TCA_MPLS_LABEL]	=3D NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
> +	[TCA_MPLS_LABEL]	=3D NLA_POLICY_VALIDATE_FN(NLA_BINARY,
> +							 valid_label),
>  	[TCA_MPLS_TC]		=3D NLA_POLICY_RANGE(NLA_U8, 0, 7),
>  	[TCA_MPLS_TTL]		=3D NLA_POLICY_MIN(NLA_U8, 1),
>  	[TCA_MPLS_BOS]		=3D NLA_POLICY_RANGE(NLA_U8, 0, 1),

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
