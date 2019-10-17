Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3705DA46F
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 05:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407240AbfJQD4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 23:56:43 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44044 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389125AbfJQD4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 23:56:43 -0400
Received: by mail-pl1-f194.google.com with SMTP id q15so435118pll.11;
        Wed, 16 Oct 2019 20:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aPnmy2DU0b21XWlpMbKZFBze+tsZNMuSeILMVgY/Yd0=;
        b=A5JTFWXGgNLoUzBUEVeKZtf9ka+WnBCigrcSuxm6xN2X9cSuLCnXVL24iZwPCTyL6w
         VZ4jUgmZ9CPLDjk5HVOSsYIHeYPYkRaEGFpRIYLV60gwc+OrAt+E1o/ukg5Tp+1rpfi4
         o0yMxytocykQH0DkWnO4ld37UN0GrbhdG8cw36062E4P0eZfXoujql+r8/BQ/A3+CkH6
         nKHLczRpF32ibZUHBGr3X+PhXJqTMczlIFXCGe1fdhOeC4p6HyOUOcxr+H6mFI2fa1nD
         q8AJcglrPtW5sdpJ0pABXdPwehGADOv00++pd1QsBET0ujiBjC4XiWphBqxUJLObpEe2
         G/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aPnmy2DU0b21XWlpMbKZFBze+tsZNMuSeILMVgY/Yd0=;
        b=YyxnAhe6LHVklzumfeirC8F845eKJAxsR8c16utkLsrwLKlxTECGvD37KgFGDjqU7Z
         vJ+jbV8rdYWR4npJld7RJyoZo6mOe6GF8moeYB7wGwMuIe6iPfKlIcIn7w2F/mJHGS5k
         14ptoCR1zUGa4XPqmJhov7w+QRxuf9c8To20Spud3oiThsEb4AU8eyho65wX3pmT44g6
         iHmkT11MwH5z2cLYbNwup4ISbAoTp/0aLaU6nNsnRml15/EGnkZlBPe5vOQtRiK3hKpt
         CjV2I5jWv0Fxb0hWyBDwQdWpH8Pc0qNBZk5GM1XniKpu5OMkL9sm39HIOvFmU/6Ku2UQ
         SnqA==
X-Gm-Message-State: APjAAAWZ6GAzDbNTgEWz9+7oDVWUSdWVnOdYJeELqIm09ZYY00aubMVI
        f7bVJDZJUDWgnOA0nNw7M12qQTzo
X-Google-Smtp-Source: APXvYqxEkQJzYZeCjCb2EyVNj316QydfyEckj3H/6YvWz9SVEl4bJXCEpqV7r6oDVlJtHe0luOBt9g==
X-Received: by 2002:a17:902:8507:: with SMTP id bj7mr1650939plb.73.1571284601899;
        Wed, 16 Oct 2019 20:56:41 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r81sm637414pgr.17.2019.10.16.20.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 20:56:41 -0700 (PDT)
Subject: Re: [PATCH net 4/4] net: bcmgenet: reset 40nm EPHY on energy detect
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
 <1571267192-16720-5-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dfd439ee-8296-93d8-d007-631e8a232a88@gmail.com>
Date:   Wed, 16 Oct 2019 20:56:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1571267192-16720-5-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/2019 4:06 PM, Doug Berger wrote:
> The EPHY integrated into the 40nm Set-Top Box devices can falsely
> detect energy when connected to a disabled peer interface. When the
> peer interface is enabled the EPHY will detect and report the link
> as active, but on occasion may get into a state where it is not
> able to exchange data with the connected GENET MAC. This issue has
> not been observed when the link parameters are auto-negotiated;
> however, it has been observed with a manually configured link.
> 
> It has been empirically determined that issuing a soft reset to the
> EPHY when energy is detected prevents it from getting into this bad
> state.
> 
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
