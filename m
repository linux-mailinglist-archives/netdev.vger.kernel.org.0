Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002E45721A2
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 19:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiGLRUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 13:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbiGLRUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 13:20:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EEB62B8E8D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 10:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657646438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/bGlhR2C9Bbup3g3CXkgqiri2zsfVzF4PubM7oVkOco=;
        b=AZruPFQUkYz7IVp2luvPG5Sxqgrr2xu/bMRcazkCvvkTuwyUEDvAJSs2wn3TS0L8fDkAZT
        sp4VAI97ubUyQbLmAhlCyCXotulpOIeQ1Eu6sAXMrOt55P1nUpHLht99Zv2lCT2Y2mX1E2
        yCTMSMWypPBRU9bWLnkTH1UovGU4RmA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-Yl9QEFoGNS-usHOMiGY7LA-1; Tue, 12 Jul 2022 13:20:37 -0400
X-MC-Unique: Yl9QEFoGNS-usHOMiGY7LA-1
Received: by mail-wm1-f70.google.com with SMTP id l22-20020a05600c089600b003a2ebd4c837so1677321wmp.0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 10:20:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/bGlhR2C9Bbup3g3CXkgqiri2zsfVzF4PubM7oVkOco=;
        b=6lcN/4tQuqpjdxhuVo6VHDxWrhJAvctXFNDET9KM54ogPY3twnuplJIcG4gH/VKAQF
         0oavCFk94nKzQuw3BPzoOT2vI6XYzoJftziZj0OCR6Bf77nSMYjkjwn892VC0+y4yjR6
         8fmtGsayNTgZv+GWFdm2BCMIp3Fu00tbEMO5C/z3Vo8TYxhZH9J7FMat/hEn3/k1RZpf
         ggTEym+AXSoKG9qwQc7qu4ImC2culztlPu5FwjwJzLApo7OHFVz9eg061fYPWPLPafSJ
         /ZvDVn1Fh776ZuTIotcXuusvnxx10m77lPMa2qqEd0s6DBwdqOFWyvnE53kblb4mheah
         YhlQ==
X-Gm-Message-State: AJIora+IsdEuhhdjf9JD7LKuBsna5EgsJ9sF2AvtL2b9Clu+jpl8psm0
        ZhbSVsct/V6NiBwbT/sq5JTotA9H+88O5U0krGr3cna+/ku0wjWXZhn29S5oYbE+AzWc5/2coGU
        /J+uO3Y0zb/ymFhXW
X-Received: by 2002:a5d:40cc:0:b0:21d:68ce:4a71 with SMTP id b12-20020a5d40cc000000b0021d68ce4a71mr22431762wrq.195.1657646436244;
        Tue, 12 Jul 2022 10:20:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1veC7eQiWcQZEt5/vXbhWczGvcEmYYjNL8gLbeWovr3kMYq72JfuaErbNpIzTWYHRRxn8V0Rw==
X-Received: by 2002:a5d:40cc:0:b0:21d:68ce:4a71 with SMTP id b12-20020a5d40cc000000b0021d68ce4a71mr22431743wrq.195.1657646436011;
        Tue, 12 Jul 2022 10:20:36 -0700 (PDT)
Received: from localhost.localdomain ([185.233.130.50])
        by smtp.gmail.com with ESMTPSA id b18-20020a5d45d2000000b0021d7ff34df7sm10296317wrs.117.2022.07.12.10.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 10:20:34 -0700 (PDT)
Date:   Tue, 12 Jul 2022 19:20:18 +0200
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
Subject: Re: [RFC PATCH net-next v4 1/4] flow_dissector: Add PPPoE dissectors
Message-ID: <20220712172018.GA3794@localhost.localdomain>
References: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
 <20220708122421.19309-2-marcin.szycik@linux.intel.com>
 <20220708190528.GB3166@debian.home>
 <MW4PR11MB57767AD317D175D260362539FD879@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB57767AD317D175D260362539FD879@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:23:50AM +0000, Drewek, Wojciech wrote:
> > > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> > > index a4c6057c7097..af0d429b9a26 100644
> > > --- a/include/net/flow_dissector.h
> > > +++ b/include/net/flow_dissector.h
> > > @@ -261,6 +261,18 @@ struct flow_dissector_key_num_of_vlans {
> > >  	u8 num_of_vlans;
> > >  };
> > >
> > > +/**
> > > + * struct flow_dissector_key_pppoe:
> > > + * @session_id: pppoe session id
> > > + * @ppp_proto: ppp protocol
> > > + * @type: pppoe eth type
> > > + */
> > > +struct flow_dissector_key_pppoe {
> > > +	__be16 session_id;
> > > +	__be16 ppp_proto;
> > > +	__be16 type;
> > 
> > I don't understand the need for the new 'type' field.
> 
> Let's say user want to add below filter with just protocol field:
> tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses action drop
> 
> cls_flower would set basic.n_proto to ETH_P_PPP_SES, then PPPoE packet
> arrives with ppp_proto = PPP_IP, which means that in  __skb_flow_dissect basic.n_proto is going to
> be set to ETH_P_IP. We have a mismatch here cls_flower set basic.n_proto to ETH_P_PPP_SES and
> flow_dissector set it to ETH_P_IP. That's why in such example basic.n_proto has to be set to 0 (it works the same 
> with vlans) and key_pppoe::type has to be used. In other words basic.n_proto can't be used for storing
> ETH_P_PPP_SES because it will store encapsulated protocol.
> 
> We could also use it to match on ETH_P_PPP_DISC.

Thanks for the explanation. That makes sense.

> > > @@ -1214,26 +1250,60 @@ bool __skb_flow_dissect(const struct net *net,
> > >  			struct pppoe_hdr hdr;
> > >  			__be16 proto;
> > >  		} *hdr, _hdr;
> > > +		__be16 ppp_proto;
> > > +
> > >  		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
> > >  		if (!hdr) {
> > >  			fdret = FLOW_DISSECT_RET_OUT_BAD;
> > >  			break;
> > >  		}
> > >
> > > -		nhoff += PPPOE_SES_HLEN;
> > > -		switch (hdr->proto) {
> > > -		case htons(PPP_IP):
> > > +		if (!is_pppoe_ses_hdr_valid(hdr->hdr)) {
> > > +			fdret = FLOW_DISSECT_RET_OUT_BAD;
> > > +			break;
> > > +		}
> > > +
> > > +		/* least significant bit of the first byte
> > > +		 * indicates if protocol field was compressed
> > > +		 */
> > > +		if (hdr->proto & 1) {
> > > +			ppp_proto = hdr->proto << 8;
> > 
> > This is little endian specific code. We can't make such assumptions.
> 
> Both ppp_proto and hdr->prot are stored in __be16 so left shift by 8 bits
> should always be ok, am I right?

Sorry, I don't understand. How could the test and the bit shift
operation give the correct result on a big endian machine?

Let's say we handle an IPv4 packet and the PPP protocol field isn't
compressed. That is, protocol is 0x0021.
On a big endian machine 'hdr->proto & 1' is true and the bit shift sets
ppp_proto to 0x2100, while the code should have left the original value
untouched.

> Should I use cpu_to_be16 on both 1 and 8. Is that what you mean?

I can't see how cpu_to_be16() could help here. I was thinking of simply
using ntohs(hdr->proto).

