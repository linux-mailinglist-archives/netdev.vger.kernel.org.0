Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49513FBDB4
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 22:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhH3U7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 16:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbhH3U6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 16:58:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86085C061575;
        Mon, 30 Aug 2021 13:58:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so374197pjc.3;
        Mon, 30 Aug 2021 13:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wCOTcT4aDgkVs5iOttnpiCbbWmKqiOCvsGsS29KMnVI=;
        b=nSjWBAyABcIj/Tcr9MQ1eq6PF0/JE7WIdQCH1KM/kA4xbkJKohX9oIaipsNgnloCIA
         l72wmfq89Cv0YfR3otP8/WFajqtZEVUg3XJd3fyy8W1abaxjDmE8c4WErs0d+PttQR0X
         ytPMEy8TYpGTg8OE7xEp+lRYTHdd3UKF1u9e427kiEzEKTl26HTNmv9ieVwpXcKm0Rig
         f0FY1y0WPhe2jyYxwY0LqFZeqIpm3lV1U8/Q2fhXUEhC4y56E5IPv39zN/mE6mpHKGmR
         P+itEElqo+rea05iwMoNiYi22t7OVLfJFU13ry91z4lELoaWnoHTccYKhUxoTdwp+jO1
         ZfBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wCOTcT4aDgkVs5iOttnpiCbbWmKqiOCvsGsS29KMnVI=;
        b=C42GM6Orz5pRauCN7mcliTS971G+atGs1US1571CJps1GJZFU7OaT799y4ZNzSdF+a
         XybCNFRJ0pJRZ3bdn7Xnxp4d5iuqNTxSFm3s+dmqyoyewCmczFSo25UoTUFRutkLoV7z
         sJjOAGBinW7RTT7s6ouMsCypb24WwdYH2HK2AN+RQF1SNNF+B42NIN0x+CFdNDRO/0FL
         50isbcQ2++GGE9dVDRf/De4wXJ5VdOGUQoBx7bMLj8c+CslM3Fou7E6wJgP+z2nZ0V0g
         RxzNDcdnLCJA9UsfELdB9uHh2eCDGFMTDxtUcFd+JRAk5m4ORKY9lbV7vSZEtOJSGOza
         dK/Q==
X-Gm-Message-State: AOAM5309LK5RLgAYUXwRkJWF3/N5zPzQM3GwW3J1UFaNZmHyN5tCbyOq
        8wdW8oTrqyu+HeGt34B3J3cvvlEW33Q=
X-Google-Smtp-Source: ABdhPJyyB7uhFyxEIgMP2A0oPDvmFLCM+SX00jvt+VPSQuUIlCuXEpFmk1yczmsJq4+EoZxuDG62+Q==
X-Received: by 2002:a17:90a:9cd:: with SMTP id 71mr1123018pjo.62.1630357081078;
        Mon, 30 Aug 2021 13:58:01 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t4sm14962859pfe.166.2021.08.30.13.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 13:58:00 -0700 (PDT)
Date:   Mon, 30 Aug 2021 13:57:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210830205758.GA26230@hoboy.vegasvil.org>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
 <20210829080512.3573627-2-maciej.machnikowski@intel.com>
 <20210829151017.GA6016@hoboy.vegasvil.org>
 <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 04:42:55PM +0000, Machnikowski, Maciej wrote:

> Please take a look at the 10.2 Operation modes of the G.8264 and at the Figure A.1
> which depicts the EEC. This interface is to report the status of the EEC.

Well, I read it, and it is still fairly high level with no mention at
all of "DPLL".  I hope that the new RTNL states will cover other
possible EEC implementations, too.

The "Reference source selection mechanism" is also quite vague.  Your
patch is more specific:

+enum if_eec_src {
+       IF_EEC_SRC_INVALID = 0,
+       IF_EEC_SRC_UNKNOWN,
+       IF_EEC_SRC_SYNCE,
+       IF_EEC_SRC_GNSS,
+       IF_EEC_SRC_PTP,
+       IF_EEC_SRC_EXT,
+       __IF_EEC_SRC_MAX,
+};

But I guess your list is reasonable.  It can always be expanded, right?


> If you prefer EEC over DPLL I'm fine with the name change. I think it will be less confusing.

Yes, thanks for doing that.

Thanks,
Richard
