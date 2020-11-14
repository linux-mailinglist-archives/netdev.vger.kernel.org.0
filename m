Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CE92B2AE8
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgKNC5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNC5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 21:57:08 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A182BC0613D1;
        Fri, 13 Nov 2020 18:57:08 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id s2so5450640plr.9;
        Fri, 13 Nov 2020 18:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y7PcyZ605gjOrpi73JwhlRzdDSnwawKE7lgwWDwY0Ro=;
        b=Hqw9Mg+aaiygTirEfZCJiA+t522Ga1uLgMtl8v8fuUZUKdA3mNuq4RFcuHS+Y50ZRj
         W1EtvR+sat++lIs3ej5mEU2zLyETftpP8KOKyHxU/Wy9SgxlDN8AV3XIu0klhdoP3W7O
         4csEt4aG5SgsWaN7cLCjyB5FiQEh2zNS4GhgG1CQBIrFSYC//7GHUWU8JKnuAHFUfBxg
         0BbDsMliqRNHsLi+OjqfsKGUZkR3jfzt9fzdSG0a5cEwByHbl8qwog/NzRCKjFdfj59g
         FTp8iIOlbE5qUTxjq5QJ0a346fu6MBuZSv9qhchrvsc8pEJJ4zaJt4AT0BbXtRi/hpQf
         AKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y7PcyZ605gjOrpi73JwhlRzdDSnwawKE7lgwWDwY0Ro=;
        b=DOwitqnMMgdQTlZe4Xm+TNPM0Pxyuj4fsxSkuoXLO3b9hvS1Oqk0zmXxZ9j5Iq24kc
         Nt4hsEtC8OlrxqNF2VbcQAqMRoRt2vsMZs0VHisS8awcIM1FpPwZs5QxudRqcD7NsoG0
         rNTSKFUNuIARFcE1MOsAtxIFCiUUngUK08/+bvbm6QUPxs3X7NqrssOSkd/lvLE/wTMg
         d9OsRoZh+2Bpqo0XJ7SesDa5Rgfhj75J1VblEzQdxTZpCEp5uiFUPYmcN8K8MnBRAgu4
         ObYBP7PqIaEUep3hJ9Xyf7ciActYyDrcXbjw0zZL1qy0Eno8MbhA/R468EqShf6zk5gL
         pBZg==
X-Gm-Message-State: AOAM533aDSMNYPq/+NXM41/TK2hJbAra5mDvTP5tmvB7xGAlFPCShWQ8
        vEe1dP6w+O7IL2F6zfvFSag=
X-Google-Smtp-Source: ABdhPJxtU/Xk5xwDndF5Gfxi0O0JqOfhnJKCFD8uF/l3T4kxY6E+uhI+OSxRhqSn8AaxP8+cxUpiCQ==
X-Received: by 2002:a17:90b:3648:: with SMTP id nh8mr5779223pjb.27.1605322628178;
        Fri, 13 Nov 2020 18:57:08 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n68sm10989716pfn.161.2020.11.13.18.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 18:57:07 -0800 (PST)
Date:   Fri, 13 Nov 2020 18:57:04 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20201114025704.GA15240@hoboy.vegasvil.org>
References: <20201112093203.GH1559650@localhost>
 <87pn4i6svv.fsf@intel.com>
 <20201113032451.GB32138@hoboy.vegasvil.org>
 <87ima96pj1.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ima96pj1.fsf@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 11:10:58AM -0800, Vinicius Costa Gomes wrote:
> I am proposing a series that adds support for PCIe PTM (for the igc
> driver), exporting the values via the PTP_SYS_OFFSET_PRECISE ioctl().
> 
> The way PTM works in the NIC I have, kind of forces me to start the PTM
> dialogs during initialization, and they are kept running in background,
> what the _PRECISE ioctl() does is basically collecting the most recent
> measurement.

What is a PTM?  Why does a PTM have dialogs?  Can it talk?

Forgive my total ignorance!

Thanks,
Richard
