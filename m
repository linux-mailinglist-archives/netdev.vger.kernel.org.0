Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2BF3CE84D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355819AbhGSQj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347574AbhGSQgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:36 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BACC0613B1
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:56 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id m3so17380806qkm.10
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dlE2FIHxhT4pSQzB331nLuefXxuBNamuExUBcaZ4IFo=;
        b=iri+5dBnSIrXjpwGmyyrt7E8QxfIgi/O4hRcP9AbhBysgTP1Au77lDgO1MOWyBT2iE
         f6ccajjpsqiZ1UUkKuVOueJyDiJEdJ8Y4EDT1hite/VU4IkHVtgCV92s3/A5rK7BTJsd
         reBEFffAuY/vKskQ8m+gOqTMROjt5AtxcKHmV8ptMV18/BKMJA9m+ii7/KnnhfGNxPV+
         DtutAHWgKRjeBsXgnSkViSMVoPtYhgNDXis5T02IeJlcmlklo12YCdmYb72rJ44ZNErt
         aWDziNfjeMWDdg8RCTOo0bamFINnsCXKaxAUEVH4Noq/vemECnITRHu4TfKQOt4un8GR
         NDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dlE2FIHxhT4pSQzB331nLuefXxuBNamuExUBcaZ4IFo=;
        b=pO3d++mtk1Jo8q+CFDm7nCLLGIXNdAyzoR5ilzBfx63/IPctKk8obO6dN++lKBmA+C
         fBpezG8YcoTbIvl3SkP03uexPRKyGi+GS5IbKrt3gM5XgVrq1CjSDpbYnR0Ez7E1oWd7
         xnaLzQte1uAKmgMfIXveMe7m+Ahk9WtDusP24V80tVHgfC3XHDc2WQa6iFEddpjPf0AX
         bx2glPDc94o430D6pJsLUL+qNuoE1JuYEW65Jsbaq7jNU/nxT+or76yeraGrWRtNO8f3
         o1555YouPzsyT98irE8eWUpov5iz1TwRDRLLEWLCO2CmjHlinmEUsgiKK0C98Bj00JJ+
         oK0w==
X-Gm-Message-State: AOAM532PSx9SoeYl1CB6KUk9CLlzJgW2+hR0JBkc2OxVMzr9e3EgUBLS
        7O5JCHqQ5RtRCZAwOjFCAmA=
X-Google-Smtp-Source: ABdhPJw41xW0CKANfgBhgRnUky33kvhjCLDtSBVNhIwEG5Nd8mlfZOL/+v50q2EOWuM3fjNK641Nnw==
X-Received: by 2002:a37:a557:: with SMTP id o84mr24713886qke.323.1626714609312;
        Mon, 19 Jul 2021 10:10:09 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:194:8382:2ab0:871:9ac6:c7bd:f923])
        by smtp.gmail.com with ESMTPSA id n14sm14818qti.47.2021.07.19.10.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:08 -0700 (PDT)
Date:   Mon, 19 Jul 2021 10:10:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ruud Bos <ruud.bos@hbkworld.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP
 pin functions on 82580/i354/i350
Message-ID: <20210719171006.GC5568@hoboy.vegasvil.org>
References: <AM0PR09MB42765A3A3BCB3852A26E6F0EF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
 <YPWMHagXlVCgpYqN@lunn.ch>
 <AM0PR09MB42766646ADEF80E5C54D7EA8F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR09MB42766646ADEF80E5C54D7EA8F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 02:45:06PM +0000, Ruud Bos wrote:
> Do I need to resend again?

No need, this time I saw it.

Thanks,
Richard
