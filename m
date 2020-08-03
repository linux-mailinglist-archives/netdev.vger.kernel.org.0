Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E946A23A82A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgHCOOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgHCOOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:14:45 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F946C061756
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 07:14:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f1so33821152wro.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 07:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FLbHjv6sJwixVTPUkFoWSHRhodSffvVZyVRd7tIiasg=;
        b=B2zEn/cTAPCSpXohJxxE9xLki5PX7qj9FmnR22H1MmYxjKdSSg9r8fn9D17nOWsVtF
         fpVS7mehInJffm1ZUCUB5jRQIx1fCpAgsTJyn2PNCjOChfYXSZ1Uox5t9Jt35RUxLJaU
         +/wMv7/H2JoJ+vt+M0cl367/9AZOYXG6Pk2fjwfbYyh2u3ZBqLWaw6MpROnuZniEy+w2
         tzfUUvPNKwKzIeuwp/UoeEj/GZu6ToI2fNUJAzVG3Hr5Hg+JmYyWq0jc1ZSvubOs6x8D
         T0gEKGEVsM/4QIa6Dxq3d/Pgbq+MtlXF5j2qK1/sHPLpUiEuqHY8YMxRipZRojLA3fXZ
         mssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FLbHjv6sJwixVTPUkFoWSHRhodSffvVZyVRd7tIiasg=;
        b=Szw3EhXaZ/Km7hrQRKzY0AriCKc07TBDOHiqJRfKy5Y4/IVBOEThilGFIBtpaWtKb9
         GdCWNcyCe+wwD5FCptNGzMRfBylDGBTZLiDRsTCXaTsCoV9FZg+U6/dIvVZcG78qzo0a
         qE06TI7FI1Rr5XtUrfAtuX5Gd+PBB87H9th1FiG7WRLSHs1zzqwG/YVvJR8A1ybdQgna
         Gv4VolCtZ4IV/8mHdyZpIyKBZODCt4J2HEbtf7pqzctk2OHnQRnGrrrwTSVsCdkkVIaA
         s1sg99GiRY8DDNkX5hUyOgIKkv2oHkrUdEm5UMCpQTWKSKnDwKo4vsCGgJ1zkwMODjA+
         O31A==
X-Gm-Message-State: AOAM530sbvBG7mCfOATQdRYKYZEuAYqiQ8uUYBcT06wtRxQf0nKIdGoR
        QSOBtdeAiPLLYxHjnS1AZlwR1w==
X-Google-Smtp-Source: ABdhPJznD3hJfUFTjJH7UPAa7GPUSxqJFZslJTkwakD2rL934AAb7jo0NMosIKQlNHjl0AMptdyVZQ==
X-Received: by 2002:adf:a4c8:: with SMTP id h8mr15140393wrb.262.1596464083711;
        Mon, 03 Aug 2020 07:14:43 -0700 (PDT)
Received: from localhost (ip-89-176-225-97.net.upcbroadband.cz. [89.176.225.97])
        by smtp.gmail.com with ESMTPSA id i82sm19051192wmi.10.2020.08.03.07.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 07:14:43 -0700 (PDT)
Date:   Mon, 3 Aug 2020 16:14:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200803141442.GB2290@nanopsycho>
References: <20200728135808.GC2207@nanopsycho>
 <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
 <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
 <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
 <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
 <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 01, 2020 at 11:32:25PM CEST, moshe@mellanox.com wrote:
>
>On 7/31/2020 2:11 AM, Jakub Kicinski wrote:
>> On Thu, 30 Jul 2020 15:30:45 +0300 Moshe Shemesh wrote:
>> > > > > My expectations would be that the driver must perform the lowest
>> > > > > reset level possible that satisfies the requested functional change.
>> > > > > IOW driver may do more, in fact it should be acceptable for the
>> > > > > driver to always for a full HW reset (unless --live or other
>> > > > > constraint is specified).
>> > > > OK, but some combinations may still not be valid for specific driver
>> > > > even if it tries lowest level possible.
>> > > Can you give an example?
>> > For example take the combination of fw-live-patch and param-init.
>> > 
>> > The fw-live-patch needs no re-initialization, while the param-init
>> > requires driver re-initialization.
>> > 
>> > So the only way to do that is to the one command after the other, not
>> > really combining.
>> You need to read my responses more carefully. I don't have
>> fw-live-patch in my proposal. The operation is fw-activate,
>> --live is independent and an constraint, not an operation.
>
>
>OK, I probably didn't get the whole picture right.
>
>I am not sure I got it yet, please review if that's the uAPI that you mean
>to:
>
>devlink dev reload [ net-ns-respawn { PID | NAME | ID } ] [ driver-param-init
>] [ fw-activate [ --live] ]

Jakub, why do you prefer to have another extra level-specific option
"live"? I think it is clear to have it as a separate level. The behaviour
of the operation is quite different.


>
>
>Also, I recall that before devlink param was added the devlink reload was
>used for devlink resources.

Yes. That was the primary usecase. That is also why mlxsw does fw reset,
because the fw reset is needed in order to pass resources configuration.

So I don't think that the name should be "driver-param-init" as it is
not specific to params.


>
>I am not sure it is still used for devlink resources as I don't see it in the
>code of devlink reload.
>
>But if it is we probably should add it as another operation.
>
>Jiri, please comment on that.
>
