Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2087563BB5F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiK2IRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiK2IRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:17:22 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829EA57B4F
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:17:20 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id n21so31817072ejb.9
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jhOk0CdNSDtJHxje5LBGeb+/+yFufzNr3T4cZgdY134=;
        b=BDLERadDAd9QSE0IY6ECgS9kiJhhexm1HTJNjHnHZRdUSi0e7CKDr8AjHR87ztwGOu
         r8/WGu69nIeIAgMIAQh4XSkWLBdX0fyGusn5mJmpeVlheFOf5CsS9C507fKGfbpiitzQ
         ihsgfArMaj713EpolS0lHx4kT0hGfxqslwfbtutdaVv+imbjwZoZ+8SlYAT1Fwz/XiCf
         lk/rX/+W/EjUK7Ti0N/awYHp4YkP9yqYg07ixw3dL7EJYVMpJwsP/qAAqScE2D8CEKb2
         r3nhf/rotjjlYCjBc+fzTa1IG0Id8VEQiVcB8bVvb9Yk9o69Enc8yQVdEXo8az4ImRLf
         pWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhOk0CdNSDtJHxje5LBGeb+/+yFufzNr3T4cZgdY134=;
        b=SHfTOefqJgH7HApLg5/SeD6TtIInyUAJ8JPqq0gXzdQcdJlDgad/npW0xXK6LW10MY
         SsPUmAecAZSobFkmbQ1vkgtQUKXwGQKIwK35O93ksuc9M4dMVIE4yvzjkoRB/aE4Ww4d
         Qh79c9V+afAaEhc82vME/PjmQ4RivSoaNvOjF+5AIRD+EsgtRDKlROm5ImtOWwFjmbP7
         cSRDN9YlVKcEFGYGS4yVmF5dvl/9CnHlmZKyMjnlAaJMhvQt309PBLufrByDsEQ7hdZY
         1xCGZaMnY/MONOn+oyfjHfcFBpwfyLwJac4NL/PNLf3yzFs7hKQRNrf3zMYuz4ZyhP1+
         Wa6Q==
X-Gm-Message-State: ANoB5plbG8GVDnJUkhMKbNs/dm2SpmpCLiR/e7Cxk42HY8JrS+5who7p
        UoiX2oSZzy84PCMWcGBwNcSbFB+N7FfD66rx7zo=
X-Google-Smtp-Source: AA0mqf4rNEixo87bgh9gDoKXqzqQXyTAM3lCvBjWByML6OOpBspWmu8udiL9KM6je/w7Q9G5zwnjsQ==
X-Received: by 2002:a17:906:b844:b0:7bf:f00b:d1a3 with SMTP id ga4-20020a170906b84400b007bff00bd1a3mr7444539ejb.739.1669709839136;
        Tue, 29 Nov 2022 00:17:19 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id gc34-20020a1709072b2200b00772061034dbsm5855458ejc.182.2022.11.29.00.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:17:18 -0800 (PST)
Date:   Tue, 29 Nov 2022 09:17:17 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 6/9] devlink: support directly reading from
 region memory
Message-ID: <Y4XADTlOkROnuaWL@nanopsycho>
References: <20221128203647.1198669-1-jacob.e.keller@intel.com>
 <20221128203647.1198669-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128203647.1198669-7-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 28, 2022 at 09:36:44PM CET, jacob.e.keller@intel.com wrote:
>To read from a region, user space must currently request a new snapshot of
>the region and then read from that snapshot. This can sometimes be overkill
>if user space only reads a tiny portion. They first create the snapshot,
>then request a read, then destroy the snapshot.
>
>For regions which have a single underlying "contents", it makes sense to
>allow supporting direct reading of the region data.
>
>Extend the DEVLINK_CMD_REGION_READ to allow direct reading from a region if
>requested via the new DEVLINK_ATTR_REGION_DIRECT. If this attribute is set,
>then perform a direct read instead of using a snapshot. Direct read is
>mutually exclusive with DEVLINK_ATTR_REGION_SNAPSHOT_ID, and care is taken
>to ensure that we reject commands which provide incorrect attributes.
>
>Regions must enable support for direct read by implementing the .read()
>callback function. If a region does not support such direct reads, a
>suitable extended error message is reported.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
