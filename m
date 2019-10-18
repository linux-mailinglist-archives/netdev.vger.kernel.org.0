Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40FDDD53D
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbfJRXQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:16:23 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:44739 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbfJRXQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:16:23 -0400
Received: by mail-lf1-f49.google.com with SMTP id q12so5847281lfc.11
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XgJtyebDCO0c24YV8YkKkh9VxVpPK3zWcYZ3oQhyysg=;
        b=gHgzp1lC4OptneZ0OFGBw0HpHN+bXygZ2PiyMA23/3eiz30DOb3P1Oj5P5CS5s2Aq9
         MBzcaQMXeXL8Pw7ibBBIwTWPj09Qn5AA6QbCKyflWKL81Ht4G4pI7ADpCYcY+sj+mgZO
         IpMclsb46GDipb+OQ1qTwNDT7CkyJHjqOcEqPfR15ATz1CCz9SbTUSDU0G5Sc/HwPL7/
         hgZU6wuVJy2pqQ1Lt3joBi3QuHuxc2yYEPhEDgm586TUnkTK6TXB6oXYBt+XnA6K/UCf
         Fzoq3Z4reb65pMn2cdEaGzI4JahwWhZLH/cQWqlGZuCGrrE17tjPycIJXniS4zaZ1zL0
         UPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XgJtyebDCO0c24YV8YkKkh9VxVpPK3zWcYZ3oQhyysg=;
        b=kFcBWM18AUVcbxkpVBrI2Nkn+P9C/8ezII/pv8Emv+yCa4MdFWLGUhqWFZ4L4bEyQh
         4Hu8IBCSkcQhFxqRBp+tA0spqe0rnwByoR8yqnNKwM/YYUzGtBYSFD3IVz1YRKxna1bO
         i6F4+8o+PbfAU2UCH2gH4GaESj/ONl0/p+dDcbVXcyZsKMbkj7jk7Lf0y9e9LgiW7BLp
         t4lDif6V0Y6XYaOeKhXjPEpwnQZar72aSvsp1jSWhAZJPaGiN/LWA2eJEpo6uBTv+baa
         ka7lJnYI8ppCvVNEUbCCZw6bNQ9RRWY7BqTOTdjV2vCxbTYkdiPBwr/HcLEjjeKRKJIh
         d0YA==
X-Gm-Message-State: APjAAAUqBHk07eikyGRgY4UbQQmVjbt6gUcITFCNkJ9h7lK8191fooa9
        P+G0vbQIUGfv7viX/y+iu1/Ak/qfwrs=
X-Google-Smtp-Source: APXvYqzVLbuVLWclhGlx7rhk8kKDSaPpKP98J02qKWX+nYCXQqs1pEU0yvF0KKWtcS5LbYk0IYVN9w==
X-Received: by 2002:a19:cc07:: with SMTP id c7mr7778358lfg.107.1571440581075;
        Fri, 18 Oct 2019 16:16:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f28sm3177391lfp.28.2019.10.18.16.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 16:16:20 -0700 (PDT)
Date:   Fri, 18 Oct 2019 16:16:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net 11/15] net/mlx5e: kTLS, Save a copy of the crypto info
Message-ID: <20191018161614.3b22ed45@cakuba.netronome.com>
In-Reply-To: <20191018193737.13959-12-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
        <20191018193737.13959-12-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 19:38:22 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> Do not assume the crypto info is accessible during the
> connection lifetime. Save a copy of it in the private
> TX context.

It should be around as long as the driver knows about the socket, no?
