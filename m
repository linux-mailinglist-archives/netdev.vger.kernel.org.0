Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A80BF60B1
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 18:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfKIR2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 12:28:16 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41433 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKIR2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 12:28:16 -0500
Received: by mail-pl1-f196.google.com with SMTP id d29so5709185plj.8
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 09:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iXmvJKuzGMS+aNTjizicdUcbTc9VbFkffW11ne/FTxI=;
        b=w7ip27nyf+UU1UiT5EHE+T0cN9v6+gGsNTfQ2tATS5SKHrKej+mFtU9rVy944/dXt/
         cGyLTbAqsccW1ira/2jVrc+v5r8DwTGgZd8QP2e3F0d/LLS5OPTzhhvEzbOXyw6sDpvH
         kxn+Ll26EfSE260D6v8YSRUTOUPOWrGW8k2F3uNbcQtPpsBmz6Ypa6QPWAfSzmG2hmo7
         uf4qmbbGySzmlXJlgILLeMNqm/4tRICMENh/A7fUUDUIkqPguE9jB05VzbaW5mDjjJch
         5B9aHLjBZKemJoDl5Wsw6Q7sQWzn0C5QHj79XGl7q8/UikH8wOUGcxYltAPpbzB03VV2
         ysQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iXmvJKuzGMS+aNTjizicdUcbTc9VbFkffW11ne/FTxI=;
        b=fXogQ0PUb4h7SFWSQ7uvvv5UD3MCD+NMAdMLEJGb0SL9laSIx3qGc16nfP3uzQHags
         7lVkBJkMG1rblO4W8rD9Q5XXI3J0jCuhTHGN1RDECY7PPvIV7sxyWZP2gPlOvuCDaU1N
         nxFJ0BRwRUFoDIW2Gu0esOA4Opczci2eV/qUuvRV6OXzvDS9tQNQe3Q2GkF9lABrobZ8
         mCE30slYrjznR+GxXj9chuUtN1NQgAwC+Y35chksQfLl6/jOQCfJZmVLOTWcII8AaunI
         p88yzKEDyuldsh3LRwprLXEpADFA4h40fpgkTLmmkvSSJg92EZsekSoTtDaOz/wWDEAb
         2Svw==
X-Gm-Message-State: APjAAAXns+AG3gqYXxZo6KMJ2Sc+64tBdJ0NWR3XnHs9RmPgmHOykbtb
        L0TDqsrJnNWRdfSPXfsP1AGkkA==
X-Google-Smtp-Source: APXvYqyyAZ2DzfD0ZECVqidVgGvxfeRELxDI8SDSfzcAPUtKW9GtcEYiAmTJquF3TMWr7LylGZ0EDA==
X-Received: by 2002:a17:902:b610:: with SMTP id b16mr399162pls.70.1573320492622;
        Sat, 09 Nov 2019 09:28:12 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id i16sm9009121pfa.184.2019.11.09.09.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 09:28:12 -0800 (PST)
Date:   Sat, 9 Nov 2019 09:28:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Parav Pandit <parav@mellanox.com>,
        David M <david.m.ertman@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191109092809.0af281c4@cakuba>
In-Reply-To: <20191109111809.GA9565@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
        <20191108134559.42fbceff@cakuba>
        <20191109004426.GB31761@ziepe.ca>
        <20191109084659.GB1289838@kroah.com>
        <20191109111809.GA9565@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Nov 2019 12:18:09 +0100, Jiri Pirko wrote:
> >Are these constant long email threads a way that people are just trying
> >to get me to do this work for them?  Because if it is, it's working...  
> 
> Maybe they are just confused, like I am :)

+1 :)
