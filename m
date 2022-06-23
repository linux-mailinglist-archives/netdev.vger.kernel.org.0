Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CF55576BB
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 11:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiFWJgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 05:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiFWJgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 05:36:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C17449698
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655976976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1RblD6lamHOJLDi1sp3XifpeL6OnTDlCisZUrk4lRDo=;
        b=Gj+UQIIkeBjy7X2nHuvzjshQ/D4Rofe77/uUceBUBg+e3fz4l+r2YuzaAfHSaL9qvDdCHR
        3LVw5R7KeQHRIowA0xjeu2Wp0HGRVuhJXtqonAceNdfRSCRzw5/MsfOjjGPHSGV73JJs0t
        ccAEmnYjCLIaIO2uwolY5cH5+a067RE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-juQVnF7qMA-Q1b2nq-yAuQ-1; Thu, 23 Jun 2022 05:36:15 -0400
X-MC-Unique: juQVnF7qMA-Q1b2nq-yAuQ-1
Received: by mail-ed1-f70.google.com with SMTP id z4-20020a05640240c400b004358a7d5a1dso7975963edb.2
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1RblD6lamHOJLDi1sp3XifpeL6OnTDlCisZUrk4lRDo=;
        b=ePIaG6h5w2yJ9nzCU5suy30gNnX1YRueCHBYM6F1sy1mcLGsK8hFo7P0+Ofro3OHdd
         z46jDQfLX3Mv2IB1g8LPWnJUa3+RNqZjxjRc7ZhDmPmmTKox7NjJ9+hvQBONWSG13QrB
         EOplHUVIyEqKjJt5m7v4qZEGLT9zfEKY4SK5Y2TfCbbsz92/W+S2MCPyYn6RmEJqDxRy
         3bsnZXV8SKt/fknPj9wcXDpf8BH+9fP7layozJOdb/xuquRgmX59DeKv83FPk6YB1pOP
         AWo0LK5wQubBLqqVEIjcuMKGjoPKArY9AhjKXf9CV3hePtnxTK4W85LrHJ/zBPfHu5pG
         9XQw==
X-Gm-Message-State: AJIora9KhkK9ZziKnXFr9nVfI00l/MRyDbF2a7xtKqAxdcfjBlGXLPle
        q4dAfAMk7MbhdVB1oUQ8kT1POVQkaolQMGv7khxffVTolMlOPhJEe9l0alHKTo+Q6aq2Ph+wVJK
        MJyAHEtiK5409zZjP
X-Received: by 2002:a05:6402:4301:b0:42d:e8fb:66f7 with SMTP id m1-20020a056402430100b0042de8fb66f7mr9602028edc.229.1655976973847;
        Thu, 23 Jun 2022 02:36:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uYpECn/thoY0XIWFSz+dMXhvG0PPUcN4aI5tKYgxwH0S0jUsq58NWOhEqiFhmN/8fk3wxAoQ==
X-Received: by 2002:a05:6402:4301:b0:42d:e8fb:66f7 with SMTP id m1-20020a056402430100b0042de8fb66f7mr9601992edc.229.1655976973569;
        Thu, 23 Jun 2022 02:36:13 -0700 (PDT)
Received: from [10.39.193.30] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id f16-20020a17090631d000b006f3ef214d9fsm10437263ejf.5.2022.06.23.02.36.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jun 2022 02:36:13 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     "Rosemarie O'Riorden" <roriorden@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, i.maximets@ovn.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: fix parsing of nw_proto
 for IPv6 fragments
Date:   Thu, 23 Jun 2022 11:36:11 +0200
X-Mailer: MailMate (1.14r5899)
Message-ID: <509C48AE-595C-4C21-91CD-33D2893F3577@redhat.com>
In-Reply-To: <20220621204845.9721-1-roriorden@redhat.com>
References: <20220621204845.9721-1-roriorden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21 Jun 2022, at 22:48, Rosemarie O'Riorden wrote:

> When a packet enters the OVS datapath and does not match any existing
> flows installed in the kernel flow cache, the packet will be sent to
> userspace to be parsed, and a new flow will be created. The kernel and
> OVS rely on each other to parse packet fields in the same way so that
> packets will be handled properly.
>
> As per the design document linked below, OVS expects all later IPv6
> fragments to have nw_proto=3D44 in the flow key, so they can be correct=
ly
> matched on OpenFlow rules. OpenFlow controllers create pipelines based
> on this design.
>
> This behavior was changed by the commit in the Fixes tag so that
> nw_proto equals the next_header field of the last extension header.
> However, there is no counterpart for this change in OVS userspace,
> meaning that this field is parsed differently between OVS and the
> kernel. This is a problem because OVS creates actions based on what is
> parsed in userspace, but the kernel-provided flow key is used as a matc=
h
> criteria, as described in Documentation/networking/openvswitch.rst. Thi=
s
> leads to issues such as packets incorrectly matching on a flow and thus=

> the wrong list of actions being applied to the packet. Such changes in
> packet parsing cannot be implemented without breaking the userspace.
>
> The offending commit is partially reverted to restore the expected
> behavior.
>
> The change technically made sense and there is a good reason that it wa=
s
> implemented, but it does not comply with the original design of OVS.
> If in the future someone wants to implement such a change, then it must=

> be user-configurable and disabled by default to preserve backwards
> compatibility with existing OVS versions.
>
> Cc: stable@vger.kernel.org
> Fixes: fa642f08839b ("openvswitch: Derive IP protocol number for IPv6 l=
ater frags")
> Link: https://docs.openvswitch.org/en/latest/topics/design/#fragments
> Signed-off-by: Rosemarie O'Riorden <roriorden@redhat.com>
> ---
>  net/openvswitch/flow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index 372bf54a0ca9..e20d1a973417 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -407,7 +407,7 @@ static int parse_ipv6hdr(struct sk_buff *skb, struc=
t sw_flow_key *key)
>  	if (flags & IP6_FH_F_FRAG) {
>  		if (frag_off) {
>  			key->ip.frag =3D OVS_FRAG_TYPE_LATER;
> -			key->ip.proto =3D nexthdr;
> +			key->ip.proto =3D NEXTHDR_FRAGMENT;
>  			return 0;
>  		}
>  		key->ip.frag =3D OVS_FRAG_TYPE_FIRST;
> -- =

> 2.35.3

Thanks Rosemarie, for fixing this. The change looks good to me!

Acked-by: Eelco Chaudron <echaudro@redhat.com>

