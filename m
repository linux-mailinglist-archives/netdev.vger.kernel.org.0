Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC56D4C08
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjDCPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbjDCPg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:36:29 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2C910F9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:36:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d17so29778817wrb.11
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 08:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680536185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UTqyoXrxiM/VfT9QbAr+WsepK6xZMZABkfEJYlsln5I=;
        b=XTrNW1KvKeBwt4SBC3FD2YAD3YezUqof540Qe+gojL203PjEZy+NTXt3jjwKLx+yRq
         vxFbf3yXUO1ssS20Npi/8QQ2hLculCDtnRuU08CeCRoj3i+xPDL9eN9M9vuhHjSbq3tn
         fmkETmXPafvxAB7bIFWFp+9yJ8GFGYP3hIZHit8/4wR8HSkl8D22FDOowSVUbXwlqxHu
         FNiVpF9wHK7hH8Q4ed1dp9yZK56oUoKWhdEgqeEeaWhauBCVJTWTDd0Uh8jm2hlQTlwp
         qBOJG6N9drmNYyZpyr8ThIhxpJuiv6uvXX/owaFTHAKikqp6W5oEl48DOthBGaqqF6EI
         yHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680536185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTqyoXrxiM/VfT9QbAr+WsepK6xZMZABkfEJYlsln5I=;
        b=gjtYC4BZ9vNGVDRsWCmC1UwZPPm8pQyFNpKBer/gxedyCzs3yTmtSA9Sj5Vo9R3jgm
         AiDMsyPsmgPZ9f1UuW4jhlkCQGwlH3BLVSnE+qv+yK8PpSleprtk9xnNNHf5dmj0v5sa
         YsKqYeAj+jflJ+4wbfEO5k3jx4DyHH0IZWGpOU3+m0M74Vl++kxB7+ZQmhFvu9cDoPh5
         BSo2ZvernpFTUpnCUsa61k+PPk3DIuGXmZstjiLWHdiW/22TL2zbgy5RPnNaORhgXmc1
         ohnjiq6y769ix93koBlTpBcvsic1Nq/yIY0incrRfaBqAyIkNkLxLH82wuFFt2KIDGGQ
         mP7w==
X-Gm-Message-State: AAQBX9dIX10vj+2a8k58C+dyB/0lIigHVykVoLoIPQe/duGr16oyVoiW
        rUuaKjQs5gKrAicAkRBkE5+trwPeHxTKabRe
X-Google-Smtp-Source: AKy350b8swK70LTW4t+7PN/+ZS6ADhjpn5NTvB7aeXF1bUauSjFGfZvjg7RsiLAJQDN+I1o43oaA0g==
X-Received: by 2002:adf:ecc4:0:b0:2d2:22eb:824a with SMTP id s4-20020adfecc4000000b002d222eb824amr28309474wro.34.1680536184887;
        Mon, 03 Apr 2023 08:36:24 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id l32-20020a05600c1d2000b003f0321c22basm18327251wms.12.2023.04.03.08.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 08:36:24 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Mon, 3 Apr 2023 17:36:22 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v2 1/2] net: flower: add support for matching
 cfm fields
Message-ID: <fokufd5lc6mcexzte3x22dfd4x4sdjo3i24tjucdolfwmrx2au@3l45wabn7cuz>
References: <20230402151031.531534-1-zahari.doychev@linux.com>
 <20230402151031.531534-2-zahari.doychev@linux.com>
 <ZCrolLu2cLbB0Xim@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCrolLu2cLbB0Xim@corigine.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 04:54:12PM +0200, Simon Horman wrote:
> On Sun, Apr 02, 2023 at 05:10:30PM +0200, Zahari Doychev wrote:
> > From: Zahari Doychev <zdoychev@maxlinear.com>
> > 
> > Add support to the tc flower classifier to match based on fields in CFM
> > information elements like level and opcode.
> > 
> > tc filter add dev ens6 ingress protocol 802.1q \
> > 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> > 	action drop
> > 
> > Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Hi Zahari,
> 
> thanks for your patch.
> Some initial feedback from my side follows.
> 
> > ---
> >  include/net/flow_dissector.h |  21 +++++++
> >  include/uapi/linux/pkt_cls.h |   9 +++
> >  net/core/flow_dissector.c    |  29 ++++++++++
> >  net/sched/cls_flower.c       | 108 ++++++++++++++++++++++++++++++++++-
> >  4 files changed, 166 insertions(+), 1 deletion(-)
> 
> FWIIW I would have split the flow dissector and cls flower
> changes into separate patches.

I think it makes sense so I would do it.

> 
> > 
> > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> > index 5ccf52ef8809..e1e7e51db88f 100644
> > --- a/include/net/flow_dissector.h
> > +++ b/include/net/flow_dissector.h
> > @@ -297,6 +297,26 @@ struct flow_dissector_key_l2tpv3 {
> >  	__be32 session_id;
> >  };
> >  
> > +/**
> > + * struct flow_dissector_key_cfm
> > + * @mdl_ver: maintenance domain level(mdl) and cfm protocol version
> > + * @opcode: code specifying a type of cfm protocol packet
> > + *
> > + * See 802.1ag, ITU-T G.8013/Y.1731
> > + *         1               2
> > + * |7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|
> > + * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > + * | mdl | version |     opcode    |
> > + * +-----+---------+-+-+-+-+-+-+-+-+
> > + */
> > +struct flow_dissector_key_cfm {
> > +	u8	mdl_ver;
> > +	u8	opcode;
> > +};
> > +
> > +#define FLOW_DIS_CFM_MDL_MASK	 7
> > +#define FLOW_DIS_CFM_MDL_SHIFT	 5
> 
> I think that if you used GENMASK to create the mask,
> and then FIELD_PREP/FIELD_GET to use the mask you
> could avoid _SHIFT entirely. Which might be cleaner.

It was proposed in the previous version for different part but it applies here
as well so I would change it.

> 
> ...
> 
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 25fb0bbc310f..7c694e7b9917 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -547,6 +547,29 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
> >  	return FLOW_DISSECT_RET_OUT_GOOD;
> >  }
> >  
> > +static enum flow_dissect_ret
> > +__skb_flow_dissect_cfm(const struct sk_buff *skb,
> > +		       struct flow_dissector *flow_dissector,
> > +		       void *target_container, const void *data,
> > +		       int nhoff, int hlen)
> > +{
> > +	struct flow_dissector_key_cfm *key, *hdr, _hdr;
> > +
> > +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CFM))
> > +		return FLOW_DISSECT_RET_OUT_GOOD;
> > +
> > +	hdr = __skb_header_pointer(skb, nhoff, sizeof(*key), data, hlen, &_hdr);
> > +	if (!hdr)
> > +		return FLOW_DISSECT_RET_OUT_BAD;
> > +
> > +	key = skb_flow_dissector_target(flow_dissector, FLOW_DISSECTOR_KEY_CFM,
> > +					target_container);
> > +
> > +	*key = *hdr;
> 
> It is unusual to just copy the header directly to the key.
> But as both are two u8 values I guess it is fine.

I was wondering about this so I would use the fields here.

> 
> > +
> > +	return  FLOW_DISSECT_RET_OUT_GOOD;
> > +}
> > +
> >  static enum flow_dissect_ret
> >  __skb_flow_dissect_gre(const struct sk_buff *skb,
> >  		       struct flow_dissector_key_control *key_control,
> > @@ -1390,6 +1413,12 @@ bool __skb_flow_dissect(const struct net *net,
> >  		break;
> >  	}
> >  
> > +	case htons(ETH_P_CFM): {
> > +		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
> > +					       target_container, data,
> > +					       nhoff, hlen);
> 
> I do like that you moved the handling into it's own function.
> But I do also note that this style differs from adjacent code in this
> file.

I would prefer to have an own function here as I find __skb_flow_dissect
long enough already. But if you insist I am okay to change it.

Thanks
Zahari

> 
> > +		break;
> > +	}
> >  	default:
> >  		fdret = FLOW_DISSECT_RET_OUT_BAD;
> >  		break;
> 
> ...
