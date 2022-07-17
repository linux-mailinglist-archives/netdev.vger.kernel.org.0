Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95A25775E1
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 13:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiGQLPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 07:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGQLPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 07:15:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00EBC13D7A
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 04:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658056535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c9j88y9s6Hkg8UgciFOzJU9nfQvd1FfPp989+Uo9r2M=;
        b=f0mHIilQIeJ5wM1tNxftFxwETl9R6iz2rV6EFpcENxoRvEqCQeQPgSSnRlG4RYG6o8QI5T
        g5Tpbuz8sDxVOHTgUmfaow5hxYVut8tFW7HNQqlry9FSZiMNXrAj7jXki5tpiaoZX2rlTH
        hGuiZ1lJshbZwTGT7l9nfkMTYDw36B8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-c6t_4GqTPoaqOy_fp7Xfaw-1; Sun, 17 Jul 2022 07:15:33 -0400
X-MC-Unique: c6t_4GqTPoaqOy_fp7Xfaw-1
Received: by mail-wm1-f72.google.com with SMTP id r82-20020a1c4455000000b003a300020352so3604941wma.5
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 04:15:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c9j88y9s6Hkg8UgciFOzJU9nfQvd1FfPp989+Uo9r2M=;
        b=KU/NALGBfvGTZ4/U2vZELN3AMtgqvRZrqM1HDK1zlQ3q+amOrW92L0horh5aF5Bh5d
         WVqIlNWLg0k/DEXlnkPvjQV3KfCVSXHn30UIO+2zuFWD6zcimtCME5ViM08iGSAm+Uka
         CUzlUCncoKk+uwsnJlAytPjND05guLr0IGWch+IRHywxAA1PVuTCMz6ttKFevtxr7+rW
         Fiz+2GykeD2WFKWg8/4dIsK0O8q3VGFFLTBdTRG0SfLp5a+95YiBfkodkPoRJr6tv5gU
         OuvurenZAzj2apOBze8YmqpiDITAFSpsRBZ+OoV3OFxLBeD2WdgmGwzYjGy2PTSXHpRK
         NA7Q==
X-Gm-Message-State: AJIora8/RDDW2OnOkwetx3KhLLgHY2UCJIo4KPSkkSc5h7XfDMdhK9EV
        zim21DGJsWEUwUJ6w/yDbO0B7Lff58rqu3Lh70FyhyETN7XAQxvSjd7saNAFzp84Ddy336mJbRi
        4BZeVRNySRC+E2Cbb
X-Received: by 2002:a05:600c:6012:b0:3a3:1b6c:f308 with SMTP id az18-20020a05600c601200b003a31b6cf308mr299234wmb.91.1658056532556;
        Sun, 17 Jul 2022 04:15:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uGpGXedM2PCLHQ7X12Al7EQkZHSC3hNbJVLlpSEPCwdukFoGVzUkp40agh9RpJKms1cpEWDg==
X-Received: by 2002:a05:600c:6012:b0:3a3:1b6c:f308 with SMTP id az18-20020a05600c601200b003a31b6cf308mr299227wmb.91.1658056532364;
        Sun, 17 Jul 2022 04:15:32 -0700 (PDT)
Received: from localhost.localdomain ([185.233.130.50])
        by smtp.gmail.com with ESMTPSA id a10-20020adfe5ca000000b0021d77625d90sm8133671wrn.79.2022.07.17.04.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 04:15:31 -0700 (PDT)
Date:   Sun, 17 Jul 2022 13:15:23 +0200
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
Message-ID: <20220717111523.GA3118@localhost.localdomain>
References: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
 <20220708122421.19309-2-marcin.szycik@linux.intel.com>
 <20220708190528.GB3166@debian.home>
 <MW4PR11MB57767AD317D175D260362539FD879@MW4PR11MB5776.namprd11.prod.outlook.com>
 <20220712172018.GA3794@localhost.localdomain>
 <MW4PR11MB577640BD1BAC97D3BB27A339FD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <MW4PR11MB57763D9CD8EA3F31DB7E3E19FD899@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB57763D9CD8EA3F31DB7E3E19FD899@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 01:54:35PM +0000, Drewek, Wojciech wrote:
> I think this should work with both LE and BE arch, what do you think Guillaume?
> We don't want to spam so much with next versions so maybe it is better
> to ask earlier.
> 
> 	u16 ppp_proto;
> 
> 	ppp_proto = ntohs(hdr->proto);
> 	if (ppp_proto & 256) {
> 		ppp_proto = htons(ppp_proto >> 8);
> 		nhoff += PPPOE_SES_HLEN - 1;
> 	} else {
> 		ppp_proto = htons(ppp_proto);
> 		nhoff += PPPOE_SES_HLEN;
> 	}

Sorry for responding late. I was away this week (and will be next week
too) and have very sporadic (and slow) Internet connection and limitted
time for review. I saw you've sent a v5 with this code, I'll reply
there. Thanks for being so patient.

