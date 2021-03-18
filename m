Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4843407D0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhCRO1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhCRO05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:26:57 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE388C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:26:56 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id va9so4262741ejb.12
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=US2IMEIjnZij9pT3t0LOukKlE2xk9YuhRx9SQ6islv8=;
        b=G9zbBjYv9fZGB52Z/vay9HjwxvrMKBIdTMOgy2vsTMn3yrKHGAAhcNZGZ+gDVw6pz7
         9IsabbEhrMkCI9jC8rgxG3ILkMIAP2y0eeTGe+F7MC2iZ2K1HJfsfXxl6qKc7tfw9ucK
         5qpu9pVGPYSr/VA4ti5FeMqG8KSHKEhSSM9uL4JDWb75PIY3fMz6mCWMRK8uuqtM1DFA
         SuDU7NV0qEkXL6OyGMWckLre0WeTo6ZjIzQj/+DVCXXpHMinMRnhxwzgKwMsQxUOzVso
         4yGNXN8FeDtOdOmicWcH2aHAkM4WUJzL38b7x3lNGU3OPMZgjaNoG4iAcRo1H/fsm64M
         2VmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=US2IMEIjnZij9pT3t0LOukKlE2xk9YuhRx9SQ6islv8=;
        b=BZReRyOKn8S3PQ28z8KFa9xEih7KFQfOyI65CFGA88TgKzhbFB65hZg7Wgr10M2BGj
         SETIeeznmxKXYZjtIv97zu+ClPx+oQ1GCEQLA/U/blTab5uu79TQPduu19e896SQzvmM
         yoUkoFcxzOYWTSK+7pyiyXcrP91SkFIEMt/NgLVSwLVUPpIDsMKPV8IukVpBQatSm286
         b4I8sDdZZuqAuvP4x8bCcGb37cINXQdvTeAJVx4fCJ+WckXCVjG5zQbtKW1xNMvLrEoj
         sAFwRl5ZOBTQjLXf2sLHxS0FpXCXMjrLWV/2BbtXaNElIRW//+ZP1V1TMV58rUrFL+wt
         EnYg==
X-Gm-Message-State: AOAM533spH1UGZ++p/oaVvuGylmvQIWHVIumTfZq5NM/60r7pIp7yL0u
        Gl8SwfPAp7qSlm8stdrkIuo=
X-Google-Smtp-Source: ABdhPJyl59o3PVKvddrRg6WxemNMoOqjWdmGPzh6h+AS72toYo6ppfQw7R2M5G4XuMszjLngbtoA+g==
X-Received: by 2002:a17:906:4055:: with SMTP id y21mr35949314ejj.507.1616077615617;
        Thu, 18 Mar 2021 07:26:55 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q10sm2257471eds.67.2021.03.18.07.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:26:55 -0700 (PDT)
Date:   Thu, 18 Mar 2021 16:26:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/8] net: dsa: mv88e6xxx: Provide generic VTU
 iterator
Message-ID: <20210318142653.2mi4icumodijuecz@skbuf>
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318141550.646383-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:15:45PM +0100, Tobias Waldekranz wrote:
> Move the intricacies of correctly iterating over the VTU to a common
> implementation.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
