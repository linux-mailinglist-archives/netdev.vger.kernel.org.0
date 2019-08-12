Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA95897F5
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfHLHhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:37:45 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:44212 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfHLHho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 03:37:44 -0400
Received: by mail-pg1-f171.google.com with SMTP id i18so49057577pgl.11
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 00:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1Ai9Le/B9TSGGCYaZL7tOIf6thntP7W+OBLICgrdQBQ=;
        b=DDoooee0/v1a1kI738NJzLdcHL9huDWWr/YE6J53sdmEf7TeHF/uUt1NY92fD1V2Ct
         CDd5HHjiwr60wq1fVSK7RuhX9dPw9XzL8pSzT+uBc4LQhvaGi+vgHIRJGvTYhspstTCR
         qv09NB19xeAgsvVnTbeyPJY53FAIw8txnLWOETIT8y6VYMw5Ecp4soiO5cwRj32dC9My
         2Ld5sz5CngNmWwae/n0/uu2iknNVDLs2Cd5gWT+1h1OS/XSQ1Ya6mcIOb7Sa+OWdWD0a
         svmkbRXGKOR1Glz15EEPdYfPynSNw9EMy3MuJfLMJo39PS4sxqhIVJ1emaUQWIfxDpEg
         LEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Ai9Le/B9TSGGCYaZL7tOIf6thntP7W+OBLICgrdQBQ=;
        b=r0/FR4SdYM5vOlz+EiV7rENbfS5Xj1yCTPmYCvC1fv4DeyznpI3yVNMTtlZlFPoLAz
         GGPfTfHSNarpy4ejcPwJBOEejCiRIHcDid9YjuFdtwmdio5wA8o3A9QukG/75Dzdrhk1
         YzYiFvKppBLnmjAZY6sEClOBQHdvhPLkVXOjzbO+h8afvRKFwNrmYBIAe0eDyMoKjROD
         Wy4L0j/NZCfIpUQ2eTxSXDPPZeaYSQGN7nyc+WbBllrOg3NaXOCpYH1ewgwRVen0cy9W
         v7y/QCNN3J0YC3GjDk31REcvHHNpS5PiimWVLMDXrOzLCZOPKsNF9fyIYzBY60IB551P
         BsIA==
X-Gm-Message-State: APjAAAUKFD/MdOl+FSqiZcRl4TZ99HQ2NIxeYjNuIGJwhTTMocVbrMKI
        PM93tZsiBTZj3OOsTdeqzfxNNYTniihSdw==
X-Google-Smtp-Source: APXvYqzOctNp8kmLXti1J6p3wajvvbrD5c+8IdhM6vT85VIaY+hi/vRsDNtQeYTP8KIl3XpQeCcCtg==
X-Received: by 2002:a65:6401:: with SMTP id a1mr29111050pgv.42.1565595463962;
        Mon, 12 Aug 2019 00:37:43 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f20sm128919107pgg.56.2019.08.12.00.37.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 00:37:43 -0700 (PDT)
Date:   Mon, 12 Aug 2019 15:37:34 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, joe@perches.com, tlfalcon@linux.ibm.com
Subject: Re: [PATCHv2 net 0/2] Add netdev_level_ratelimited to avoid netdev
 msg flush
Message-ID: <20190812073733.GV18865@dhcp-12-139.nay.redhat.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
 <20190809002941.15341-1-liuhangbin@gmail.com>
 <20190811.210820.1168889173898610979.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811.210820.1168889173898610979.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 09:08:20PM -0700, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Fri,  9 Aug 2019 08:29:39 +0800
> 
> > ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table

> > error when add more thann 256 memberships in one multicast group. I haven't
> > found this issue on other driver. It looks like an ibm driver issue and need
> > to be fixed separately.
> 
> You need to root cause and fix the reason this message appears so much.
> 
> Once I let you rate limit the message you will have zero incentive to
> fix the real problem and fix it.

Sorry, I'm not familiar with ibmveth driver...

Hi Thomas,

Would you please help check why this issue happens

Thanks
Hangbbin
