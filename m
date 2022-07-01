Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E17563395
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbiGAMlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbiGAMlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A63A403D0
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 05:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656679300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o3gY8Y5UYdPpN54/a6touCU5SVfDsdz3NaUMVHi2oAs=;
        b=JCNB1mbapCDJqR/xwsBZwtw39l1cqo4Xi9QGVuNgiWS/zxFDAxeJcS6Tm/4/8MA4am4WzL
        5I9IOBgCjFmCKoTGJ0YMnsDhWeIX8czZXuZeiglIHcoI/e2Y8BN1aWeAme+lV7T9Sc+36n
        RVFHGqGCaBeiVgpVdumlDbzf5GCJwoo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-oDMuceyKMs28saJ3Wuyuig-1; Fri, 01 Jul 2022 08:41:39 -0400
X-MC-Unique: oDMuceyKMs28saJ3Wuyuig-1
Received: by mail-wm1-f69.google.com with SMTP id j35-20020a05600c1c2300b003a167dfa0ecso1356359wms.5
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 05:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o3gY8Y5UYdPpN54/a6touCU5SVfDsdz3NaUMVHi2oAs=;
        b=lX8/L63YIRdjDocTL7xF68jTjZp+y55SBYmFIArOp4abgJTbBYg5NEY/6pE6V/qMUT
         0aB/HiD1E+411nIbyTyCOdtgSPrxJ/F4+8b4P6xWfI8Vh+MWn1di5qRQei37YyPicrIS
         DaDAuMlSC6nVuQ7lC4/hRCGeSCiLNoKM9KVhQ+0xipLbH1a/6oUP5QJ2o8VavXxb+dmI
         ULnMQnqWKjqolkt9P6dRgnjdNDsW2Z1NiwdJ39tdu4ayK7+38wvT1pGZQOBFyU1VkE4R
         GDgQOAb4r83Xw3zWKK6QaL4RyR8anLW4iS98/jXODf6X4K941CuKgDAQXX6xra6eeVLF
         Z2pQ==
X-Gm-Message-State: AJIora8X8OIqApDJu2LdMCATJE/ZpQIseSkcwNAxbxMS7O6BhCBNbvSa
        znZYsvd78asldfOhc65GnAZfxAlid5Nah5t3DUO8wfWm5kLfYRIuSdMasxYVFlux4izF6LeVbZp
        Iw4Zv9klxGUtaL0Xu
X-Received: by 2002:a05:600c:154f:b0:3a0:54f9:4388 with SMTP id f15-20020a05600c154f00b003a054f94388mr15620854wmg.16.1656679297888;
        Fri, 01 Jul 2022 05:41:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vgdC8gWbOXAxOYoLXChRELY3YnmUdXS3/+2QWssNOB7zQ/plmFSx8GLyuo1tdTE9k0/w7+PQ==
X-Received: by 2002:a05:600c:154f:b0:3a0:54f9:4388 with SMTP id f15-20020a05600c154f00b003a054f94388mr15620780wmg.16.1656679297199;
        Fri, 01 Jul 2022 05:41:37 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id x10-20020a5d54ca000000b0021b85664636sm21770332wrv.16.2022.07.01.05.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 05:41:35 -0700 (PDT)
Date:   Fri, 1 Jul 2022 14:41:33 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "mostrows@earthlink.net" <mostrows@earthlink.net>,
        "paulus@samba.org" <paulus@samba.org>
Subject: Re: [RFC PATCH net-next v3 1/4] flow_dissector: Add PPPoE dissectors
Message-ID: <20220701124133.GA10226@debian.home>
References: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
 <20220629143859.209028-2-marcin.szycik@linux.intel.com>
 <20220630231016.GA392@debian.home>
 <MW4PR11MB5776F1388A0EFB83990120CDFDBD9@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB5776F1388A0EFB83990120CDFDBD9@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:53:51AM +0000, Drewek, Wojciech wrote:
> > > +/**
> > > + * struct flow_dissector_key_pppoe:
> > > + * @session_id: pppoe session id
> > > + * @ppp_proto: ppp protocol
> > > + */
> > > +struct flow_dissector_key_pppoe {
> > > +	u16 session_id;
> > > +	__be16 ppp_proto;
> > > +};
> > 
> > Why isn't session_id __be16 too?
> 
> I've got general impression that storing protocols values
> in big endian is a standard through out the code and other values like vlan_id
> don't have to be stored in big endian, but maybe it's just my illusion :)
> I can change that in v3.

I don't know of any written rule, but looking at other keys, every
protocol field is stored with the endianess used on the wire. Only
metadata are stored in host byte order. For flow_dissector_key_vlan,
vlan_id is a bit special since it's only 12 bits long, but other vlan
fields are stored in big endian (vlan_tci is __be16 for example). And
vlan ids are special for another reason too: they're also metadata
stored in skbuffs because of vlan hardware offload.

But PPPoE Session Id is clearly read from the packet header, where it's
stored in network byte order.

> > Also, I'm not sure I like mixing the PPPoE session ID and PPP protocol
> > fields in the same structure: they're part of two different protocols.
> > However, I can't anticipate any technical problem in doing so, and I
> > guess there's no easy way to let the flow dissector parse the PPP
> > header independently. So well, maybe we don't have choice...
> 
> We are not planning to match on other fields from PPP protocol so
> separate structure just for it is not needed I guess.

FTR, I believe it's okay to take this shortcut but for different
reasons:

 * When transported over PPPoE, PPP frames are not supposed to have
   address and control fields. Therefore, in this case, the PPP header
   is limitted to the protocol field, so the dissector key would never
   have to be extended.

 * It's unlikely enough that we'd ever have any other protocol
   transporting PPP frames to implement in the flow dissector.
   Therefore, independent PPP dissection code probably won't be needed
   (even if one wants to add support for L2TP or PPTP in the flow
   dissector, that probably should be done with tunnel metadata, like
   VXLAN).

 * We have gotos for jumping to "network" or "transport" header dissection
   (proto_again and ip_proto_again), but no place to restart at the "link"
   header and no way to tell what type of link layer header we're
   requesting to parse (Ethernet or PPP).

For all these reasons, I believe your approach is an acceptable
shortcut. But I don't buy the "let's limit the flow dissector to what
we plan to support in ice" argument.

> > > @@ -1221,19 +1254,29 @@ bool __skb_flow_dissect(const struct net *net,
> > >  		}
> > >
> > >  		nhoff += PPPOE_SES_HLEN;
> > > -		switch (hdr->proto) {
> > > -		case htons(PPP_IP):
> > > +		if (hdr->proto == htons(PPP_IP)) {
> > >  			proto = htons(ETH_P_IP);
> > >  			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> > > -			break;
> > > -		case htons(PPP_IPV6):
> > > +		} else if (hdr->proto == htons(PPP_IPV6)) {
> > >  			proto = htons(ETH_P_IPV6);
> > >  			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> > > -			break;
> > 
> > 1)
> > Looks like you could easily handle MPLS too. Did you skip it on
> > purpose? (not enough users to justify writing and maintaining
> > the code?).
> > 
> > I don't mean MPLS has to be supported; I'd just like to know if it was
> > considered.
> 
> Yes, exactly as you write, not enough users, but I can see thet MPLS should
> be easy to implement so I'll include it in the next version.

Okay.

> > 2)
> > Also this whole test is a bit weak: the version, type and code fields
> > must have precise values for the PPPoE Session packet to be valid.
> > If either version or type is different than 1, then the packet
> > advertises a new version of the protocol that we don't know how to parse
> > (or most probably the packet was forged or corrupted). A non-zero code
> > is also invalid.
> > 
> > I know the code was already like this before your patch, but it's
> > probably better to fix it before implementing hardware offload.
> 
> Sure, I'll add packet validation in next version.

Great!

> > 3)
> > Finally, the PPP protocol could be compressed and stored in 1 byte
> > instead of 2. This case wasn't handled before your patch, but I think
> > that should be fixed too before implementing hardware offload.
> 
> We faced that issue but we couldn't find out what indicates
> when ppp protocol is stored in 1 byte instead of 2.

That depends on the least significant bit of the first byte. If it's 0
then the next byte is also part of the protocol field. If it's one,
the protocol is "compressed" (that is the high order 0x00 byte has been
stripped and we're left with only the least significant byte).

This is explained more formally in RFC 1661 section 2 (PPP Encapsulation):
  https://datatracker.ietf.org/doc/html/rfc1661#section-2

and section 6.5 (Protocol-Field-Compression (PFC)):
  https://datatracker.ietf.org/doc/html/rfc1661#section-6.5

There should be no reason to use this old PPP feature with PPPoE, but
it's still valid (even though it breaks IP header alignment).

