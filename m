Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2593A5065B4
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 09:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349298AbiDSHZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 03:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349297AbiDSHZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 03:25:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D86D1326E5
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650352948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZr6M/RZmb6/46Ixt/CqkBe4H7W2TOgxImOhZARYVog=;
        b=EI/4AAmnIu3wmfQvlJ4UB5ReLPMZEHaMsW05umbeihC74+jsNvNNnlVt3ZxQYH3I9vmD3c
        i84xfhAxrg1vujMyw3JwfpRrgo9ziwpIhtbr2yEBlzMSaO63U4U5QF4n80FGwcgw2pcJno
        9F7flApOb5wD0wUp9xrwTANFKypXji4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-RU84bcAMMvK1WQGVw87cMw-1; Tue, 19 Apr 2022 03:22:26 -0400
X-MC-Unique: RU84bcAMMvK1WQGVw87cMw-1
Received: by mail-wm1-f69.google.com with SMTP id b12-20020a05600c4e0c00b003914432b970so797046wmq.8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eZr6M/RZmb6/46Ixt/CqkBe4H7W2TOgxImOhZARYVog=;
        b=6bju4y6skg7AdYL7wvqhPTk9aCTAnAtBIz4IcNlOGU4ywkjrBQEtJkh/ECk5ex1YrK
         GoSqe51wCL9zGuIfCtKrO6nQMLrj0Srp1QB2hWIkYphS+v169Y15a9Wli3LE6/HFiUUQ
         Ee5na1mX2GYvpQYvIJBJ2+9X+cufjnvQUkhpQVXLeOnK+z9z76qTIXaKntiV3ATRB1Nl
         RrwnpxN2Txk2eTrh1YI6UpQKCqzfYdF8orlVKXFKeEj/0QjtsIv5dwJAZbXi/sumuuUe
         1DZWz+6cCTf0YAj86avxmQpLOZ2W9GVNWPB0LT6XHO4bj9KzZ7PWt1eLBD0ATico+jKB
         nasA==
X-Gm-Message-State: AOAM530DRDMk8hKZvtndiKY0WDN9ejH9PlwsBxlpSiZZ7nAurg9DnuqJ
        N1oyDAKyQ9s5KjEWhgAF74B2xjkcnK42UuIGJ8E4UNRD992AwkP+dpFhzxuZhFdxNpgM+ftnnEk
        Ho+XO9ZbXpwKnnvDF
X-Received: by 2002:a05:600c:3582:b0:391:e041:f3a2 with SMTP id p2-20020a05600c358200b00391e041f3a2mr17301836wmq.126.1650352943532;
        Tue, 19 Apr 2022 00:22:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/UeOtJ/J4radpq0TyJONOLz7bLBbt8qoF30bJsYeesbS32A7rfqg+FAUl2auACvPnfCtwWA==
X-Received: by 2002:a05:600c:3582:b0:391:e041:f3a2 with SMTP id p2-20020a05600c358200b00391e041f3a2mr17301814wmq.126.1650352943276;
        Tue, 19 Apr 2022 00:22:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id f4-20020a7bc8c4000000b0038ebbe10c5esm18408233wml.25.2022.04.19.00.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 00:22:22 -0700 (PDT)
Message-ID: <5cd406e8f8e77f6025d77ec1e0e46296694002d4.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net: ethernet: Prepare cleanup of powerpc's
 asm/prom.h
From:   Paolo Abeni <pabeni@redhat.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Geoff Levand <geoff@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Date:   Tue, 19 Apr 2022 09:22:21 +0200
In-Reply-To: <f995b36fc3f2a3793038300388f06d1c3dd7e69a.1650011798.git.christophe.leroy@csgroup.eu>
References: <f995b36fc3f2a3793038300388f06d1c3dd7e69a.1650011798.git.christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Sorry for the late reply.

On Fri, 2022-04-15 at 10:39 +0200, Christophe Leroy wrote:
> powerpc's asm/prom.h brings some headers that it doesn't
> need itself.

It's probably my fault, but I really can't parse the above. Could you
please re-phrase?
> 
> In order to clean it up in a further step, first clean all
> files that include asm/prom.h
> 
> Some files don't need asm/prom.h at all. For those ones,
> just remove inclusion of asm/prom.h
> 
> Some files don't need any of the items provided by asm/prom.h,
> but need some of the headers included by asm/prom.h. For those
> ones, add the needed headers that are brought by asm/prom.h at
> the moment, then remove asm/prom.h

Do you mean a follow-up patch is needed to drop the asm/prom.h include
from such files, even if that include could be dropped now without any
fourther change?

If so, I suggest v3 should additionally drop the asm/prom.h include
where possible.


Thanks!

Paolo

