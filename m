Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101356465D8
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLHA10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLHA1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:27:21 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0788D650
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 16:27:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g10so18611863plo.11
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 16:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sTLU0g7abHXK6tyV8frYWuCmJfXq1AR0BCEAZVs5ods=;
        b=Jdv3l6nJDSGEybIhRlTgbiMPuC1L1pUHIhVVtbC+VVnoOMoBGfFobT24YSQ1HGtHmT
         q1VfBCRC8NTlHcLBXC5hgv10Y7c0HWZeaLxvNJIHg/DZYmbhlJJhWePCtsqGk2sDr57i
         9F82d+ruz2UU7kcsEICqJalLEqRp8amvDhCOjaiUwxOeUh3S0vbEgCuWYVo4KCO9LVhk
         WygvS7dXkQgz0aOuCXplDeFsd2SVYV3Q6CqHjgCQUMyGvJO8SdOPsBC/s5Lxh56B2Low
         LXiWXZxDeKImhgACbO4NSHJWWUa4seFrysrtMiEXchYdGB3BLuP/IWV8iGs06BCWpH1S
         LKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTLU0g7abHXK6tyV8frYWuCmJfXq1AR0BCEAZVs5ods=;
        b=FXSFt+mDNngxe/TgOQSCkkXXRaOn9SqqXYK0GrIdVc7hqRm3oQtaxR/dGp45RuJmsA
         yXQfQLZUDq99PAxP6sOJ39GxvPI4PxVjfD46FpiCIi1lQ2WnJbPEqbuJ52ecg3dA1AFc
         oVVu2AbVesvMjPXWMOtYK2qKicSyz65IfgatH2512tvWMuX7reBsSz6LYO2+0IPFZ/93
         lejQtTLSQgJYereOxOQ/TKBMOmMnvJ7in+qLvu5JaUhRx68qhsqVAd409LPOBn4hogl5
         NiUYG4m0aSRKH7E8hfaQwPzTicuxeCVLvpiVXxPAVRq1RCAe88ZsJRuraFXRqF0gkwxn
         Kc4Q==
X-Gm-Message-State: ANoB5pmAYOaWrldLHqym6cWzX2jiPoe+0xPbQLZdEZe898t3aXB720e0
        Fr5zRLwjBoSbsIIN5Fci4rI=
X-Google-Smtp-Source: AA0mqf5Hkl+vAA/HjrsCojAW1kiXaf0oXWJ08vvag4TnVYqsjl+BWn58PCZKlAfBV+tRAvLXkyi8bg==
X-Received: by 2002:a17:90b:1948:b0:219:bf1a:9dcc with SMTP id nk8-20020a17090b194800b00219bf1a9dccmr20253228pjb.56.1670459236786;
        Wed, 07 Dec 2022 16:27:16 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m17-20020a63f611000000b0047685ed724dsm11987887pgh.40.2022.12.07.16.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 16:27:16 -0800 (PST)
Date:   Wed, 7 Dec 2022 16:27:13 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 1/4] ice: Create a separate kthread to handle ptp
 extts work
Message-ID: <Y5EvYXK9V+BSU4pS@hoboy.vegasvil.org>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207211040.1099708-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 01:10:37PM -0800, Tony Nguyen wrote:
> From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
> 
> ice_ptp_extts_work() and ice_ptp_periodic_work() are both scheduled on
> the same kthread_worker pf.ptp.kworker. But, ice_ptp_periodic_work()
> sends messages to AQ and waits for responses. This causes
> ice_ptp_extts_work() to be blocked while waiting to be scheduled. This
> causes problems with the reading of the incoming signal timestamps,
> which disrupts a 100 Hz signal.
> 
> Create an additional kthread_worker pf.ptp.kworker_extts to service only
> ice_ptp_extts_work() as soon as possible.

Looks like this driver isn't using the do_aux_work callback.  That
would provide a kthread worker for free.  Why not use that?

Thanks,
Richard
