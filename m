Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF05F53A16F
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 11:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351516AbiFAJ6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 05:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351560AbiFAJ62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 05:58:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6BF164BEA
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 02:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654077498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=82uW6EP3zc+L57WVwLvvIjr2wDUWz17pBSLf4qWZW8w=;
        b=D/cDL6lXb6JNNNUH47J0mhwOQlpo02nG0snSaVkvH7kK3AXwOz8DOvB6/rmM4YyeF885pH
        Mps22KSi3iNn2Bqkx12T7dedVGEnGZ74ZtxOhDkxLEy4QvjyF1LpDSm5CfTatvNKSVUWXu
        ztleqpTJPWab5D4t2elRIMTNVa2NHjk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-yv_g-Wi8ODmMwygPAWaZ3Q-1; Wed, 01 Jun 2022 05:58:17 -0400
X-MC-Unique: yv_g-Wi8ODmMwygPAWaZ3Q-1
Received: by mail-qt1-f198.google.com with SMTP id v1-20020a05622a014100b002f93e6b1e8cso902919qtw.9
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 02:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=82uW6EP3zc+L57WVwLvvIjr2wDUWz17pBSLf4qWZW8w=;
        b=MZ57JWHakwlE0fLu3G5loGgYlDLE/7+hbB8wPt5gGJCEpDLlOCqDNgjfuWWY8Cz446
         ECYZ3rqoxaBrsNnpydA51CiGb2ITGwElkvqRLUR5V0a73khV5SrZh5+5xCxgTx2eWfeJ
         JwNmIFZNNwmI5DlQDiA255dx+5Q03+C81GDdu0ezMfg33iTavE6HLzPwCyi1ChCuNlpm
         8znmlbBd8IaCl8VofoTy1ut7eS7LpZ4bxlMaZstn2bLVsAj7kXHEuFk2EnxfWn0foJEL
         dpLLleocGgmvL/e67QWoWtK2wQp0TlZTFTWxh6wjEOgbrczcwP7t157PjNFztAyj29Wu
         rBRw==
X-Gm-Message-State: AOAM530TPzyk23F6hwknoc41X26AqOOIx7MCgxfa/RpOWB2q0G5jQG7P
        CniXsGMoqB+009zLLcRBg2au5V2mqCWdhHHj7eLbcJJYiAnYAEPHXXcm+DxeCb5Z2kYtLpO1jbt
        0JStDEkxBpiGFkR/B
X-Received: by 2002:ac8:5a07:0:b0:2f9:3f44:cbf2 with SMTP id n7-20020ac85a07000000b002f93f44cbf2mr35438351qta.374.1654077496977;
        Wed, 01 Jun 2022 02:58:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUM/uH1EMfzyt/oe9dsKBoDbn6qxA8RvrUjHsiO/kb+dC9J0+cArxgPflsfnYB9Tt0pc3J3A==
X-Received: by 2002:ac8:5a07:0:b0:2f9:3f44:cbf2 with SMTP id n7-20020ac85a07000000b002f93f44cbf2mr35438335qta.374.1654077496724;
        Wed, 01 Jun 2022 02:58:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id z24-20020ac84558000000b002f918680d80sm837267qtn.78.2022.06.01.02.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 02:58:16 -0700 (PDT)
Message-ID: <5e8ccf5fb949fb8bef822f379f7a410ccd6b6f41.camel@redhat.com>
Subject: Re: [PATCH net-next v1 1/2] net: Update bhash2 when socket's rcv
 saddr changes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev@vger.kernel.org, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, richard_siegfried@systemli.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, kuniyu@amazon.co.jp,
        dccp@vger.kernel.org, testing@vger.kernel.org,
        syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
Date:   Wed, 01 Jun 2022 11:58:12 +0200
In-Reply-To: <CANn89i+pg8guF+XeOngSMa4vUD81g=u-pCBpi0Yp2WB9PQZvdg@mail.gmail.com>
References: <20220524230400.1509219-1-joannelkoong@gmail.com>
         <20220524230400.1509219-2-joannelkoong@gmail.com>
         <CANn89i+pg8guF+XeOngSMa4vUD81g=u-pCBpi0Yp2WB9PQZvdg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-05-31 at 15:04 -0700, Eric Dumazet wrote:
> On Tue, May 24, 2022 at 4:20 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > 
> > Commit d5a42de8bdbe ("net: Add a second bind table hashed by port and
> > address") added a second bind table, bhash2, that hashes by a socket's port
> > and rcv address.
> > 
> > However, there are two cases where the socket's rcv saddr can change
> > after it has been binded:
> > 
> > 1) The case where there is a bind() call on "::" (IPADDR_ANY) and then
> > a connect() call. The kernel will assign the socket an address when it
> > handles the connect()
> > 
> > 2) In inet_sk_reselect_saddr(), which is called when rerouting fails
> > when rebuilding the sk header (invoked by inet_sk_rebuild_header)
> > 
> > In these two cases, we need to update the bhash2 table by removing the
> > entry for the old address, and adding a new entry reflecting the updated
> > address.
> > 
> > Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
> > Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> 
> Reviewed-by: Eric Dumazet <edumzet@google.com>
> 
Apparently this patch (and 2/2) did not reach the ML nor patchwork (let
alone my inbox ;). I've no idea on the root cause, sorry.

@Joanne: could you please re-post the series? (you can retain Eric's
review tag)

Thanks!

Paolo

