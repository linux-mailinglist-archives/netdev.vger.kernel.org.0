Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC5339C1A1
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 22:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhFDUxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 16:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhFDUxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 16:53:01 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A1EC061766;
        Fri,  4 Jun 2021 13:51:02 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id u24so12571586edy.11;
        Fri, 04 Jun 2021 13:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N5QT07rrgG9f9WLFe7zl63Q/6BSW+uLjUfE7eE2mKP0=;
        b=ZFuVijuEo2yHItqOwzxzVSWbeCfF/6exXrxqtieQcHh6pHI6InstArsNigaSt9VC+n
         IDT09NOi5yzZBmqyTXwsrZljCmzVMmt91ELhhWjERv/kiSesoHoH7kbNpINPqGY2mbgo
         vR/hexOk5TUgVCTzHZaA85wLuACTfrIY/U0SJiUvf4IfIBcXbtPlAiItOASto4eStL01
         JFxTkIARO9uOXrpD/SrlUYBSi7BaRJ8DyCbJVOsALRC12KZf95CHfr5c1H5ymNTx/ute
         BdUixtMTo4ZvPVoIeCgevfZ5mArGRtVnCkoTYSAMHrPh0TMe4x0z5VrfeEwPGQeWjSye
         Nx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N5QT07rrgG9f9WLFe7zl63Q/6BSW+uLjUfE7eE2mKP0=;
        b=FrQjINtDDcZlhtPGipmn+hMIVnjeEPpsBkEyWo7U9YzJ6qtamJmhkYqDfUGtPBw5ET
         nIsXHereyRZe43hCSHgH0lZfWAAVywjnNnrmp7g2covlQdzsi8mOdAVhVPE8z13tr7xr
         UV1XpCZ0K6XhoJOunTE5Zag5q1Gj9bY2dZSVgqycHgUqimjNo1xdT6yfc0iWVu5Or+fo
         cpZC/foNSKatmeM474OXxJ5xEHnQaAfMaODKpQX+pydAj+P1Q7gGYaFbquzI7JVdc386
         7ptz+n/bgYuGbLQKZekkAIF/cdFlK0gzjKJMpzUYh/iOV0DCBMBW6HUoOqbL28YMvpdG
         GCSA==
X-Gm-Message-State: AOAM533jMJcsKK/HbvqRzEclApYSABKB74gvr7eKvIMD1eVys9tB05ar
        sYul9q35HzLrv0WjRynvYNs=
X-Google-Smtp-Source: ABdhPJwoZespHv/dbtpfVtAyVAirxiDQKC4+riYeP71LbjJBgb/1CT7zdcI06HW4/WdNCwsHgEdWHw==
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr6733818edx.189.1622839861138;
        Fri, 04 Jun 2021 13:51:01 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id kb20sm3188097ejc.58.2021.06.04.13.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 13:51:00 -0700 (PDT)
Date:   Fri, 4 Jun 2021 23:50:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: xrs700x: allow HSR/PRP supervision
 dupes for node_table
Message-ID: <20210604205059.jec6ee4yon7p3whs@skbuf>
References: <20210604162922.76954-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604162922.76954-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 11:29:22AM -0500, George McCollister wrote:
> Add an inbound policy filter which matches the HSR/PRP supervision
> MAC range and forwards to the CPU port without discarding duplicates.
> This is required to correctly populate time_in[A] and time_in[B] in the
> HSR/PRP node_table. Leave the policy disabled by default and
> enable/disable it when joining/leaving hsr.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
