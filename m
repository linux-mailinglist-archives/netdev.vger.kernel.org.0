Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713A15826AC
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiG0Mck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiG0McS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:32:18 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B651CBCA8
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:32:03 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v5so10422598wmj.0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M03Kk7UMFFU1UGbmhP3LYvPI+C9czU/qa8Lxu6+tUN4=;
        b=xE0xfDnWWy6cN/kjV811nEOp1t1oFACNx+Aqcico3gzx1UKlHG66mrVecOMDQzbGV7
         +6lPEVlVXXclJOGzy4ST8jZ12eEFkFFwRgAgopvSXI7GrhkzX13r4Qxr9y14tLSSOeHs
         uz+7e6yBtcHz16FzxUzm/CyGKGnWftf+SX4ExB909EiWmOdnnlSmXh09Zv+q9ahOV1fy
         hsyboAdKvnfkKZpM3Cu9gG5d03mHOxSpZ+wA4LjPhiLBCdmcOwrM8yRa6sotlDlcqFnB
         U4SDBevwYhl9mDxm1H5nSCBYNDw+fxCxx7gUuoHtZRoMrtD7EN3TDjoxtRD5W+EIlLyc
         pr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M03Kk7UMFFU1UGbmhP3LYvPI+C9czU/qa8Lxu6+tUN4=;
        b=EDwBmItxt+gOwg33vupwXfOUHxaRLdyf06b3yKkKWn1zVyCbfrL7FoZVtsZZuZcx3O
         nUta12MK1cWd00C2vVGU9j0RuUnl+yJXrVLKngyoymnyeExn5rZutFyjsG9qLdogP9ar
         blDJaN2V0Ka6tbm0QLyqnZrN6znpyzgTly830Z/EDfRko9H9lGx1bDPkfY0YAHeMKtn7
         G7cuTF5vJyG473ZPvuVrNJptHUjDqQVnRo7/gxN6dQbbQcvQ6ZyGALtxG5X//1XKILzv
         vSQ35Ntk3ev6KhuHIY8lnObUqN2odw63X+S2Hxn0qxrw0E3t8HEnjgIU73kKZhAfzAvj
         jpOw==
X-Gm-Message-State: AJIora+aJNX0N30I97Xr7knv3oGS5Fvy6M3f0QZXCaidT29NwqNaiqBr
        h8fvnRVVn921+nXXCRoFKiaV+DphxdN5aEi4
X-Google-Smtp-Source: AGRyM1t+KZYAvXiakf/AjTsyx6653Ip+cUiMex484+A7IjWQ6LMpZkSrmln5p1yoQoZj096pEFoKkQ==
X-Received: by 2002:a05:600c:2409:b0:3a3:6036:9acf with SMTP id 9-20020a05600c240900b003a360369acfmr2888164wmp.147.1658925122153;
        Wed, 27 Jul 2022 05:32:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t6-20020a5d49c6000000b0021d221daccfsm7861092wrs.78.2022.07.27.05.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 05:32:01 -0700 (PDT)
Date:   Wed, 27 Jul 2022 14:32:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v8 2/2] bnxt_en: implement callbacks for devlink
 selftests
Message-ID: <YuEwQFirDFkC7x6O@nanopsycho>
References: <20220727092035.35938-1-vikas.gupta@broadcom.com>
 <20220727092035.35938-3-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727092035.35938-3-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 27, 2022 at 11:20:35AM CEST, vikas.gupta@broadcom.com wrote:
>From: vikas <vikas.gupta@broadcom.com>
>
>Add callbacks
>=============
>.selftest_check: returns true for flash selftest.
>.selftest_run: runs a flash selftest.
>
>Also, refactor NVM APIs so that they can be
>used with devlink and ethtool both.
>
>Signed-off-by: vikas <vikas.gupta@broadcom.com>

Wrong SOB line.


>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>


Reviewed-by: Jiri Pirko <jiri@nvidia.com>
