Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DAB69C682
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjBTIWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjBTIWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:22:15 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8507B11EAC
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 00:22:11 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id g7so1778046wrd.3
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 00:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IGSBBAXvubGnEVclUrXLSzW75ZzN8SwY9C38BY98ybk=;
        b=3gTq7v8nV3Z33iIq/KkJZcBVcMJsakIOoyMlklKdzIu9n4cpWFZ0HwKQzbLn+NwhHZ
         rRsYWmbMIhZ6r/OzjBdSEfDU25kUPupZJ+ZqH5MERcf404yoIgn1FJrQ9CQj64coiQGv
         wfAL2d4p58JOO/sHFBcJERn6NM/uQZdZ4KUpnDMQdbuWTAIKyA8ZSuGIrOCRsrOFZZUE
         FWdsvDVMOLZX02qcwE9afLUJI3nml1VABSnMM24WrlQGB/nVumOe+ZuA/9TnzvDHP3wy
         GozSccHEQcVhntnS9cJKZj+q6i7iz4a3AUgqIvffSnUKh8cU229V+UZI8cb3sDrHDUfD
         mE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGSBBAXvubGnEVclUrXLSzW75ZzN8SwY9C38BY98ybk=;
        b=ldnKSIOpatbf4ldYyVhgNDPKvoORy9sUBedD6jj9peaJXnrDN0MjRJ/cT2SXj1iZ0J
         cE8ZocVDm7NLOxu/Vnf0Kv9WdSs5m73lwhuw4akuXWX1iiFsAtFYsFavYJx+dK3EJOow
         LBM80fnPFa/AgM1fMHNHjW+8mds/jN9c7hwEhezU4yBe/Al9xGVanPWQGr6drysoDzWy
         /BdXs4lqRHmwm9Rbcc2HCyHh2pImG01nnmEJcAW5cqFagh91VvCZSdCxaqXdmSXKQJCG
         lzlWRTUbVuCZfNStcmnASom72gKK1FuZjIbT2FeC33lrHtEt7JnHT4bPNTN6TtJr5hoJ
         29vw==
X-Gm-Message-State: AO0yUKUOfAU7wjRytM057TtFncYx3SteupAYsFKNBXumF884zbXBMvXx
        symoD4WHT0GAp1V/ImDInVFpZQ==
X-Google-Smtp-Source: AK7set/UEfjHVgbGpf/iygvWrzjOJnWuAcrKkJA8t3Go4iNQyOUYOqmiWutlNbn1hj00Pt3KcGR88Q==
X-Received: by 2002:a5d:5b07:0:b0:2c6:c9f1:e444 with SMTP id bx7-20020a5d5b07000000b002c6c9f1e444mr1179048wrb.16.1676881329949;
        Mon, 20 Feb 2023 00:22:09 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v7-20020a5d6107000000b002c559626a50sm1352197wrt.13.2023.02.20.00.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 00:22:09 -0800 (PST)
Date:   Mon, 20 Feb 2023 09:22:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
Subject: Re: [PATCH v3 net-next 01/14] devlink: add enable_migration parameter
Message-ID: <Y/Mtr6hmSOy9xDGg@nanopsycho>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <20230217225558.19837-2-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217225558.19837-2-shannon.nelson@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 17, 2023 at 11:55:45PM CET, shannon.nelson@amd.com wrote:
>Add a new device generic parameter to enable/disable support
>for live migration in the devlink device.  This is intended
>primarily for a core device that supports other ports/VFs/SFs.
>Those dependent ports may need their own migratable parameter
>for individual enable/disable control.
>
>Examples:
>  $ devlink dev param set pci/0000:07:00.0 name enable_migration value true cmode runtime
>  $ devlink dev param show pci/0000:07:00.0 name enable_migration
>  pci/0000:07:00.0:
>    name enable_migration type generic
>      values:
>        cmode runtime value true
>
>Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Could you please elaborate why exactly is this needed?

From my perspective, the migration capability is something that
is related to the actual function (VF/SF).

When instantiating/configuring SF/VF, the admin ask for the particular
function to support live migration. We have port function caps now,
which is exactly where this makes sense.

See DEVLINK_PORT_FN_CAP_MIGRATABLE.
