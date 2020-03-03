Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C5C17772C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgCCNdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:33:11 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33901 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgCCNdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:33:11 -0500
Received: by mail-wm1-f68.google.com with SMTP id i10so2371436wmd.1
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 05:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mB/cJ6wU4mWVw+7refZdcQrdNzyp8urHm/mHDPav/5Y=;
        b=k/B/IFIcLzHNyhbSCg9NkUOxNerARipZeRsqHHzYYO4BG+B12HB5MQD/q6lEwn56x9
         PTsZEm6l7SV8fY6bRMsNEIgGKru8EXrVUsA06dXbWEBsR7ywC/TuZUpquO99jzmyiclN
         mDwO31HSs7kCqC7iOrU5YKtzpzQpg8uo33vB5XBVSkkySSpyE7cG/t/9tVyUDwHcsEOG
         xZTvHVe6L2RkxIqBjX5CiqerVDnJ6gpkqnyR8HdmrkL+njbG2j3zuZN/r92Ncbtbn6B/
         JXWnV34zXzij32OcUTuhl9vb++Zv1dmtAM+6JUL+NHbOqu5BfAYjFU7uzwB4Etdr9YNb
         Lo3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mB/cJ6wU4mWVw+7refZdcQrdNzyp8urHm/mHDPav/5Y=;
        b=t0sRv8DNdnGxDKpCP3iQ/vuwbCTLm1YdFSbGIYz+H5u03Kzn7v/ZISPHK6vID5EdXv
         7X49VngL1ml0TOUoZxx5VC5a+uQCvkWGKwwAvWwo/vEctTS7BEuOvbkupHer5gyE0fGa
         +tjbuVflLbWQVzd8PxJye/HMvaXfuTVFJa4QE5oDXt3tfLD6epi9cc8GhVHh521CBYX+
         ksL3yKr8+MV3zk2whZLZD4IN+gVo9srwN7NM3IsHXX9NXAhgtIvvLfCCHf8/TjTYoBJ/
         BImRIa0tLEixbqLa26V6fl6T4X+H3mTjK7sGzE9064NLFJ9+a5C70FXIMA+IKEuYAjOr
         cszw==
X-Gm-Message-State: ANhLgQ3lAHJSgHoenAVIjPIoElllL3C7Emk4+JrbLTpSwRS15ohT2nTL
        e1f6dxgnJovjudokjqAWnIas1A==
X-Google-Smtp-Source: ADFU+vv+YefEzC3i/FAU2SOWnneDmK2UkSOvBcLsvToArphpjK5qLOK+JOzR4YNSY7s9Yomgq+bjPw==
X-Received: by 2002:a05:600c:2046:: with SMTP id p6mr4101395wmg.167.1583242389494;
        Tue, 03 Mar 2020 05:33:09 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id m25sm2172301wml.35.2020.03.03.05.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:33:09 -0800 (PST)
Date:   Tue, 3 Mar 2020 14:33:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v4 1/3] net/sched: act_ct: Create nf flow table
 per zone
Message-ID: <20200303133308.GL2178@nanopsycho>
References: <1583240871-27320-1-git-send-email-paulb@mellanox.com>
 <1583240871-27320-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583240871-27320-2-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 03, 2020 at 02:07:49PM CET, paulb@mellanox.com wrote:
>Use the NF flow tables infrastructure for CT offload.
>
>Create a nf flow table per zone.
>
>Next patches will add FT entries to this table, and do
>the software offload.
>
>Signed-off-by: Paul Blakey <paulb@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
