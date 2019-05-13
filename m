Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F9B1B694
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfEMNBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:01:38 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44953 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfEMNBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 09:01:38 -0400
Received: by mail-lj1-f195.google.com with SMTP id e13so10836319ljl.11;
        Mon, 13 May 2019 06:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QGTckQOx84uQyT8SLG7DX4oMPnMfk2rseNhxH0hxL1Y=;
        b=ZEYUPzWMOW4bhGn6zz8sJ5FwdqmybndaFaFZnXX1UVgw2EARDN40BF25pVFovlifDJ
         NvQxLnjXRzh1H46Km2gRaxCa8P5Aq2YbKkUrR0QZU+8HgIJyYU8lpeXH9PeFcmsVifFw
         Ux0M72EUJq71q5syXSadws2Q/9bD33MSnZI60XxSoffyo1FbFHSzARkqave0vPtvXoUb
         doN0bjKMlQzRiNK52jYpit7Ft0mk+NkbuFZKGBZAaCzj98Uhz7uHlTR+s/oVcoF+1nYP
         jLPjm6vxj/adEhMfy3fC/tMyi2o4tQKRulCkTC8kgVdr8i0up0izbsgrKTELyJjkZIjR
         ZA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QGTckQOx84uQyT8SLG7DX4oMPnMfk2rseNhxH0hxL1Y=;
        b=ppKUz2hQpW9ALIKU5RAVwg8btk0FHx63blAt8eTllJqRwFSTgHGwbecHVz9QfCGzfL
         QJ1XEdiSNsE8ye3UVjoCef/Zj98iI0uXr1XNcU4giWllDF8mL5op28PkGtwmdfqUe0Gt
         sPYEp1k1jo4EJrJJbclrSYaeSuD+Kto9VOmTPtWuEiI2mtXH37kbEBPi790EeK6mNl32
         gA8wL+09eCwvnV3BCS7yHNx1a5nlqrtOUHISMKk5qtpbemlgo15ScykmEJW/VGP8H9WN
         Hcievdt7GTeLgXkqVqjUhBhs6q7WYJw2CkLDI3FtszCQbspsKLLNvPlH9KfgwTzSQoM5
         a9Qg==
X-Gm-Message-State: APjAAAWCXO7D7UgKGZQFO4gl/rEatEJ3LvmIMmaZBIDYDc1pnz0zys3M
        Wy12JLwEbXF/ITkwxYQNhnc=
X-Google-Smtp-Source: APXvYqxtThLzAdEQv11Vx7EYQYQNjFjlqyktYSw3YX6t61hXasQ4vUejzh7rCeeghiSHtyABvDV7RA==
X-Received: by 2002:a2e:9583:: with SMTP id w3mr8150309ljh.150.1557752495866;
        Mon, 13 May 2019 06:01:35 -0700 (PDT)
Received: from mobilestation ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id q124sm633340ljq.75.2019.05.13.06.01.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 06:01:35 -0700 (PDT)
Date:   Mon, 13 May 2019 16:01:33 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     g@lunn.ch, Vicente Bergas <vicencb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190513130131.jiommbisqvydmzgw@mobilestation>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
 <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
 <20190513102941.4ocb3tz3wmh3pj4t@mobilestation>
 <20190513105104.af7d7n337lxqac63@mobilestation>
 <cf1e81d9-6f91-41fe-a390-b9688e5707f7@gmail.com>
 <20190513124225.odm3shcfo3tsq6xk@mobilestation>
 <20190513125103.GC28969@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513125103.GC28969@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 02:51:03PM +0200, Andrew Lunn wrote:
> > Ahh, I see. Then using lock-less version of the access methods must fix the
> > problem. You could try something like this:
> 
> Kunihiko Hayash is way ahead of you.
> 
> 	 Andrew

I wouldn't say that five hours is "way ahead". But if something fixes a bug in
a patch it would be good to be have the original author being Cc'ed.

Vincente, here is a link to the patch, that fixes the problem.
https://lkml.org/lkml/2019/5/13/43

-Segey
