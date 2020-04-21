Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE11B2EB1
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgDUSCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgDUSCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 14:02:20 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA464C0610D6
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:02:19 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so17472185wrv.10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jedhYkajSim5x68P8O0CUqvP83cf6iUjoesP9C8hiFo=;
        b=y0jxbo7JS7pxVkOy/EQ0lO3zteC4bGOkZkqbUZRJQd7HhXj6yfYMqFVWevOPavaBHo
         AFqy/902jMWpJnce+p+A1JLKmUK5qTjvKFBqmBpaqpIKNpxLMMGWACUQxVb+6hSvP0zi
         Oqb8M9Q2CAKCUcH1kEijfL1M2DtrgEj6IV59dAJ+mvRowOmfUcCxlAdWEPE70obTFuWl
         tBpgBiUK4YZgV4na/9a2gfiiLyAVCgDomVDkMEtblX0ng17W8ziunFi/DA/jjz4Qn4S5
         4reUSJAOAWdeOvToxya/GkVT2spj7Qy1YYKjOcve3FBvBnU34z3ZYh504HC++2XCJvR2
         c+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jedhYkajSim5x68P8O0CUqvP83cf6iUjoesP9C8hiFo=;
        b=jIM4FeDKVYGgh0y2HGTg6txWAysptb0Kg3idMqVd2/EHOJbFrPwq6af5fv3t7RgGiR
         fPqXkYSzD/T3K0nhyPg+lBPsKOuq5bNo7krqfvWhjIT2F2ty2aq82jMTjK88DO9Kdy7E
         OoJV2yrBQXrLTHbm8VGe4e2S8GN+aU/YNx7FjQYdE5cfIuss7aT2i9apwCS1/5OX9ELl
         Rm1+86XessWNdgFLaa1Vvzdndxqp2eC8+7tjrKbSOcpnOp74/B3oJygOAj2AH4vSg8kh
         TPiCpFb9A1jl+c/u2Hi/wPHZKn3On1VZOkq4sBiOKBprQRAcz1n2TIX8ZrU+VtR+EYPG
         ouVA==
X-Gm-Message-State: AGi0Pubi7moLYhz0DM3zhKvmGdcCrpQqWc8Kzx/TyVNT1INwDx6bf0J3
        o/U7FGIAB5v6VeUyA0Ek/Gkzuw==
X-Google-Smtp-Source: APiQypJMYW6cEnVWFYz9B0ZC92+21FY7D4okV6fO2/AswQMRRwkBPJYHxakkd9GsxWVfl/WYo91lNg==
X-Received: by 2002:a5d:4dd1:: with SMTP id f17mr24133262wru.383.1587492138434;
        Tue, 21 Apr 2020 11:02:18 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s30sm4864502wrb.67.2020.04.21.11.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 11:02:17 -0700 (PDT)
Date:   Tue, 21 Apr 2020 20:02:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V3 mlx5-next 07/15] bonding: Add function to get the xmit
 slave in active-backup mode
Message-ID: <20200421180216.GF6581@nanopsycho.orion>
References: <20200421102844.23640-1-maorg@mellanox.com>
 <20200421102844.23640-8-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421102844.23640-8-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 21, 2020 at 12:28:36PM CEST, maorg@mellanox.com wrote:
>Add helper function to get the xmit slave in active-backup mode.
>It's only one line function that return the curr_active_slave,
>but it will used both in the xmit flow and by the new .ndo to get
>the xmit slave.
>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
