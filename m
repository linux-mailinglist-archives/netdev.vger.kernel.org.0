Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0E72F56E3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbhANByk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbhAMXzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 18:55:01 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63766C06179F;
        Wed, 13 Jan 2021 15:54:20 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id q22so5638845eja.2;
        Wed, 13 Jan 2021 15:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yIc90bW9hdDuSreHeH201JXVN8WhV0iJyZz/kubhn2U=;
        b=vXFOLIppPxJWwQ/+M9kwbl6rHSoPu1ihYrInNKuc57pOvlCIMJloYHPx/m4fRodCfs
         c9uDTXFot2AsQo67j+pME4UQCrtUX2Cskt4v6W0TPbLFTwG+vKWGpO7H596Nvesivddj
         T5u70ixQSGNfNl2NqzZI7acrDVh4q5HXhmf6tGM/neIhqDXriOADhggEHzi7ZZ9HKsJQ
         au+renKxLfzw2qbMCd+i1W/ICmH1lt+fWvm3lvAEPxS9OXNEIzch9hhWJnAdBPTCkjLi
         i7q1ZIQ0STU56IMMGL8aU/XUnA2b0E73WD2ZW3ivqJYsySVy4tQ4TUak18LIjtW2y0/d
         lBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yIc90bW9hdDuSreHeH201JXVN8WhV0iJyZz/kubhn2U=;
        b=b6cuFmJZbcvOuevi7CYff9o1p4vnQ8xwXPTtkPzOTbUPOXajNiabvSloM0OL5hRf8v
         1VyyOCgsWy3UiTnrdsxsZUvJPYJR/VYkKeZNj5L35sD1b33gHfggHK11k3kmYjZCC8Mi
         4Ua3AcpjvOXqBR3Ogaclf8ViImYRZv/+mOv1q3Uo+hiGGObKuFFT2wMTEGJIKyNoAgpa
         qJQltc9Aqo3xNIn7tfToJAoXd77fLsSHLh69L5PGVz0IjFkgCpMJ+3ywhsiewGiPHRDy
         d2siA0fyUDBYrQxBperJZZ1tKAJTLf22tyLmsmxcyIXcw6G+9YCbDzPfrDHrxACt/osM
         1Gug==
X-Gm-Message-State: AOAM531m1tNECa3gEBnJITHrTod0NqSgrllTy/dFunnIp1WFbV487wJl
        oJjSfhjV2FGu/ipL9pQHdoo=
X-Google-Smtp-Source: ABdhPJyYZ1w21m7na+h92rAbCAd3Hkm+q6T7DuoDX3CrEdc9lzLlIUxgGsVzO0flaBl9Nr3qbuoZFw==
X-Received: by 2002:a17:906:8051:: with SMTP id x17mr3168209ejw.430.1610582059123;
        Wed, 13 Jan 2021 15:54:19 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c12sm1439744edw.55.2021.01.13.15.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 15:54:18 -0800 (PST)
Date:   Thu, 14 Jan 2021 01:54:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 5/6] net: dsa: ksz: fix wrong pvid
Message-ID: <20210113235417.pnpsfiiq72a2cwkd@skbuf>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
 <4d34da2534c912e290d77d4296a4aa68229fd6e6.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d34da2534c912e290d77d4296a4aa68229fd6e6.1610540603.git.gilles.doffe@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:45:21PM +0100, Gilles DOFFE wrote:
> A logical 'or' was performed until now.
> So if vlan 1 is the current pvid and vlan 20 is set as the new one,
> vlan 21 is the new pvid.
> This commit fixes this by setting the right mask to set the new pvid.
> 
> Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
