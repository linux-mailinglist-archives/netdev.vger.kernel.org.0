Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE595620D51
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiKHKdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKHKdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:33:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5659B99;
        Tue,  8 Nov 2022 02:33:35 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id y14so37385581ejd.9;
        Tue, 08 Nov 2022 02:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LY1I8+2HVWBNxeSL3doZzV5pm30CTmVcmG4k1Dx3DFg=;
        b=WjZq/KJfeb+H4qWWEnA6VpqdAefMHdrFPfwPbG4rU7/zBzyHM453xt7PeZp5MfSbYx
         el1WsYwGvz+fHuGz1iXcx1oT5NtSc85t3jKd2xmp5XJ51yeihtCQzg+pdsLKvDxYr9c/
         erwmKEiaCH0qccTKrfygilmikx9xjy6z/1bkFBmoPXSOPBDcSssICFXmSBOyhXp9yauN
         cjX3QoBAhiNGr3lmo6Cwa4Lu5UfGfv+9gtbaip9d6ZLcWCrQLWbbmB27ohXtwEPgBKEh
         Q28ifYKVrt6+kANuEmw6x5MREZ/h0Wz6Cu2cgoDAmK+VzCPrK0VRzcDpcMgz+Gqh/0hi
         eqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LY1I8+2HVWBNxeSL3doZzV5pm30CTmVcmG4k1Dx3DFg=;
        b=EXFCIovVpqs3Njo8D6olZNmFuJCd+UX2cAQ9ZLXhMjU+PqB/7iOSNJauuZBc/g6BoU
         3JchyDQ83B26fxQiSie2t/LdA2MlwNxvU7Q90kj/9MitDwWAy0aK856ordSOlUrk/ZH9
         z7vZia8sTo0zEquprXZLi6qhiuyQpFMAPNK4oOVkvuvedV0lb4vP+KE5gk9PindofLUJ
         mW0mS1Bozi6IjXXXsgfi4J6yNqbY6ob4G4XeApbjytuYPsNfmMBU0TUYO4frNTYWoW+B
         UHuWNSIP3whojngqE5q36OPz7VP/GeSwyXOLFYcJzo9sjk3VE1sL+vaIEQlRQnRFDbeB
         gVBQ==
X-Gm-Message-State: ACrzQf1YW94d0ONtj1aln61xwstjv4y1gB2VtLAwI06YpfNq7jl+2H3h
        1V8elW4w/y3dS6boPcAOnQ8=
X-Google-Smtp-Source: AA0mqf7shJqKcuRIVsjUQXA9bSeVhPwXS5UK8pWpmxuV1Ei0wyY8LCwGGZP3BBPruspU6bN7ytDUBQ==
X-Received: by 2002:a17:906:a157:b0:7ae:5d04:c96 with SMTP id bu23-20020a170906a15700b007ae5d040c96mr12488986ejb.564.1667903614012;
        Tue, 08 Nov 2022 02:33:34 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id u6-20020aa7d886000000b0045723aa48ccsm5189116edq.93.2022.11.08.02.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:33:33 -0800 (PST)
Date:   Tue, 8 Nov 2022 12:33:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Message-ID: <20221108103330.xt6wi3x3ugp7bbih@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-8-nbd@nbd.name>
 <20221107215745.ascdvnxqrbw4meuv@skbuf>
 <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
 <20221108090039.imamht5iyh2bbbnl@skbuf>
 <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
 <20221108094018.6cspe3mkh3hakxpd@skbuf>
 <a9109da1-ba49-d8f4-1315-278e5c890b99@nbd.name>
 <20221108100851.tl5aqhmbc5altdwv@skbuf>
 <5dbfa404-ec02-ac41-8c9b-55f8dfb7800a@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dbfa404-ec02-ac41-8c9b-55f8dfb7800a@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:24:51AM +0100, Felix Fietkau wrote:
> On 08.11.22 11:08, Vladimir Oltean wrote:
> > On Tue, Nov 08, 2022 at 10:46:54AM +0100, Felix Fietkau wrote:
> > > I think it depends on the hardware. If you can rely on the hardware always
> > > reporting the port out-of-band, a generic "oob" tagger would be fine.
> > > In my case, it depends on whether a second non-DSA ethernet MAC is active on
> > > the same device, so I do need to continue using the "mtk" tag driver.
> > 
> > It's not only about the time dimension (always OOB, vs sometimes OOB),
> > but also about what is conveyed through the OOB tag. I can see 2 vendors
> > agreeing today on a common "oob" tagger only to diverge in the future
> > when they'll need to convey more information than just port id. What do
> > you do with the tagging protocol string names then. Gotta make them
> > unique from the get go, can't export "oob" to user space IMO.
> > 
> > > The flow dissector part is already solved: I simply used the existing
> > > .flow_dissect() tag op.
> > 
> > Yes, well this seems like a generic enough case (DSA offload tag present
> > => don't shift network header because it's where it should be) to treat
> > it in the generic flow dissector and not have to invoke any tagger-specific
> > fixup method.
> 
> In that case I think we shouldn't use METADATA_HW_PORT_MUX, since it is
> already used for other purposes. I will add a new metadata type METADATA_DSA
> instead.

Which case, flow dissector figuring out that DSA offload tag is present?
Well, the skb can only carry one dst pointer ATM, so if it's METADATA_HW_PORT_MUX
but it belongs to SR-IOV on the DSA master, we have bigger problems anyway.
So, proto == ETH_P_XDSA && have METADATA_HW_PORT_MUX should be pretty
good indication that DSA offload tag is present.

Anyway I raised this concern as well to Jakub as well. Seems to be
theoretical at the moment. Using METADATA_HW_PORT_MUX seems to be fine
right now. Can be changed later if needed; it's not ABI.
