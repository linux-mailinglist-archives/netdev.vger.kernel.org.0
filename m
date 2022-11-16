Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BDA62CBCE
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiKPVAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiKPVA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:00:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A326EB7C
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668632173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DTuWmJjejdv+SurQA0gLdWcYF6qf7avEj+rPkV8wTt0=;
        b=dkcIepzZDPh/hCVkvoVCooD4qSh9R4CTnJ8kmfwelHB3P1JTyyPMu3sekG9wcNZLrq1uTO
        hNgc259pUAbszjpxfjvEi1sgUZsKYXRnZ8W51ACGwg5oK6pvlgKpdwhRzaa/m/WrYOxaj7
        R4gNTCBb6cSB/+y3mfw9pQAjtWd2zWY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-WjUVxafTOAauFqhryKEtQQ-1; Wed, 16 Nov 2022 15:56:07 -0500
X-MC-Unique: WjUVxafTOAauFqhryKEtQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC41738041C2;
        Wed, 16 Nov 2022 20:56:06 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.19.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B96E1121314;
        Wed, 16 Nov 2022 20:56:06 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCH net-next 2/5] openvswitch: return NF_ACCEPT when
 OVS_CT_NAT is net set in info nat
References: <cover.1668527318.git.lucien.xin@gmail.com>
        <8c17d8ea9547254180031510a3160fcd97ac945f.1668527318.git.lucien.xin@gmail.com>
Date:   Wed, 16 Nov 2022 15:56:03 -0500
In-Reply-To: <8c17d8ea9547254180031510a3160fcd97ac945f.1668527318.git.lucien.xin@gmail.com>
        (Xin Long's message of "Tue, 15 Nov 2022 10:50:54 -0500")
Message-ID: <f7tk03u4o0s.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> Either OVS_CT_SRC_NAT or OVS_CT_DST_NAT is set, OVS_CT_NAT must be
> set in info->nat. Thus, if OVS_CT_NAT is not set in info->nat, it
> will definitely not do NAT but returns NF_ACCEPT in ovs_ct_nat().
>
> This patch changes nothing funcational but only makes this return
> earlier in ovs_ct_nat() to keep consistent with TC's processing
> in tcf_ct_act_nat().
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Acked-by: Aaron Conole <aconole@redhat.com>

