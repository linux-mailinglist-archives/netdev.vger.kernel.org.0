Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B881B2848EF
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 11:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgJFJCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 05:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgJFJCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 05:02:06 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B83C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 02:02:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o5so12532178wrn.13
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 02:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ELTOM63/E69ypngcYfw/PJPfhYd4cEJ7an+k4N3B6b0=;
        b=g9wi81nrJ6UmEn/MRqwSU3xumhiaQ0GlcaOw6xhEiKsSlmdZGbw38cKNFRTONJfpMI
         rShanLIbCvxjdhkiYNqPKi8Vup+zyqcTTnfz4QRxI2fGoVF/BXzxdheJLLdkAm12bFyk
         3kBeDptyUMuaNkrhRSTcA1A/T6L6yWAM6n5FeSKYE2zaV/4ekUktD7m6gzftaKqCslQR
         huR7AcNlYvOew6KNi+AYhIHETRnDzB8NwQj18Wh7qqEdGSSm3mOuAbvbqWH4Ba7Xfwi+
         fgpsN7r8/tS8zIrrqQMGr7zwKzIZg+cN6IJHlSWnWOoGC6fYbIhpRIsIOTcTbuR/xJfb
         1jtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ELTOM63/E69ypngcYfw/PJPfhYd4cEJ7an+k4N3B6b0=;
        b=nUimwXo464Hk6XC9eLoFHhot2Tce1KIseDw/P+Hg447c1NCyxN06tvCFjGGYmvF/g9
         bcxIuATK114QAj4f1WK5T2G04pqTkXF+KFqsFk6KacVELfBhgqnW8lv8xWqyJnHFyK1R
         SUKP5iJmlzrSHD5nDAwEfQGfzHwYhImdNmp8ea190rmEB7CiomBF/B35Ndx/0pHDBKzL
         0upKJV0FMmsWjQNnnyEKgDA1OrtaLJETRjTKkGT4DXr0Q8rpq8a1IWW8e6mAeORBLK3l
         gVtYzwcDB8dLip8o9uVX0fMojHNFtlf40RpMbJpH9A7+Rx33S9N4O1vbe+wqGcnHwWG1
         H54Q==
X-Gm-Message-State: AOAM530H73U3srIEoKVpLu6NP25ep5mTZEpMjElHdSIc8YZgB+fWkCmw
        2KPBjsd7sIwxw+00yslvF8l5W8T9lZcHNDZl
X-Google-Smtp-Source: ABdhPJw9C14n0661BEnE2zEAj/ACDnuST1NwREigggn7nJYJ/4H739MpvIQh/+WmIXOHfrDVMm5QuA==
X-Received: by 2002:adf:9541:: with SMTP id 59mr3734807wrs.396.1601974924384;
        Tue, 06 Oct 2020 02:02:04 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id q15sm3609684wrr.8.2020.10.06.02.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 02:02:03 -0700 (PDT)
Date:   Tue, 6 Oct 2020 11:02:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@mellanox.com, idosch@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [net-next v2 10/11] bridge: switchdev: cfm: switchdev interface
 implementation
Message-ID: <20201006090203.GA3336@nanopsycho>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
 <20201001103019.1342470-11-henrik.bjoernlund@microchip.com>
 <20201001124929.GM8264@nanopsycho>
 <20201005130712.ybbgiddb7bnbkz6h@ws.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005130712.ybbgiddb7bnbkz6h@ws.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 05, 2020 at 03:07:12PM CEST, allan.nielsen@microchip.com wrote:
>Hi Jiri
>
>On 01.10.2020 14:49, Jiri Pirko wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> 
>> Thu, Oct 01, 2020 at 12:30:18PM CEST, henrik.bjoernlund@microchip.com wrote:
>> > This is the definition of the CFM switchdev interface.
>> > 
>> > The interface consist of these objects:
>> >    SWITCHDEV_OBJ_ID_MEP_CFM,
>> >    SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM,
>> >    SWITCHDEV_OBJ_ID_CC_CONFIG_CFM,
>> >    SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM,
>> >    SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM,
>> >    SWITCHDEV_OBJ_ID_MEP_STATUS_CFM,
>> >    SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM
>> > 
>> > MEP instance add/del
>> >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_MEP_CFM)
>> >    switchdev_port_obj_del(SWITCHDEV_OBJ_ID_MEP_CFM)
>> > 
>> > MEP cofigure
>> >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM)
>> > 
>> > MEP CC cofigure
>> >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_CONFIG_CFM)
>> > 
>> > Peer MEP add/del
>> >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM)
>> >    switchdev_port_obj_del(SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM)
>> > 
>> > Start/stop CCM transmission
>> >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM)
>> > 
>> > Get MEP status
>> >       switchdev_port_obj_get(SWITCHDEV_OBJ_ID_MEP_STATUS_CFM)
>> > 
>> > Get Peer MEP status
>> >       switchdev_port_obj_get(SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM)
>> > 
>> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
>> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
>> 
>> You have to submit the driver parts as a part of this patchset.
>> Otherwise it is no good.
>Fair enough.
>
>With MRP we did it like this, and after Nik asked for details on what is
>being offload, we thought that adding this would help.
>
>The reason why we did not include the implementation of this interface
>is that it is for a new SoC which is still not fully available which is
>why we have not done the basic SwitchDev driver for it yet. But the
>basic functionality clearly needs to come first.
>
>Our preference is to continue fixing the comments we got on the pure SW
>implementation and then get back to the SwitchDev offloading.
>
>This will mean dropping the last 2 patches in the serie.
>
>Does that work for you Jiri, and Nik?

Sure.

>
>/Allan
>
