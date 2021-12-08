Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9336846D987
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhLHRXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbhLHRWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:22:45 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B06C061A32
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 09:19:13 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g14so10483616edb.8
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 09:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3cjYgBdCOvL0u91pGsjtNAxNomFkum3ZwtfMuuRVwUY=;
        b=NucLcp+6hMVjsfaDxjJYNOc77QofvfN1k/ePj6X6PMpmlu4148qmumR0VLWM6PYxSG
         RhNEYppHS7FlekTNEoDCHpsj6So7ZCmykvUWLDZofwEH8hP/alWWVy8xAmtw5gV5a1hE
         lWg5qpbuv+wI5kVoHKnrDuMqhhwp0tqVd4kxK/7vKnJvVjLERtWaFsU7DcAGXE3RCNR1
         1FwPdKMnPXX5XiHtNp77qFOHXJ00QAfWsMI/qrNLLJuEAL4CIrrfHgUb4G5dRLiEiliG
         QYNHy9mpEwTCH8/HxlddCgdUblfAbgnZDlus/gnd3Hg23yg1RaKD3eMQjeeW6nnZUCKl
         USuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3cjYgBdCOvL0u91pGsjtNAxNomFkum3ZwtfMuuRVwUY=;
        b=7OL8prO6bQwVvjq3S+FKCWTS5IiRx2SgJ3t8nPst9/azM3ZTvcxEc/7TYiWl9fWFdX
         YuU/oUhMrWq+w60YAGaTOzh9VAOlD/EBB/C5iR4aI0jSNR3M7jY4sKGOB2MRaAHiH3be
         HHTbDQUaiNPya67axtkiaOojQV/yKeb7bb4/pplL0HFRVzfebSDUG2OWjXL1QjIKFpsr
         HdPDHWDGqIRyAgx6xulYjv9ULMQMKx6AnfeofjMH9sVnc/HSD0x7wcF2L3AeEXb6gOYb
         4itn8KGckwEix/8/Deqij1zuq/iUIhWdFQLuwqO5mieP6DVOoqIevug6jiLMw97PzXhZ
         tkpA==
X-Gm-Message-State: AOAM533Ih+7dFsKkGZmoPZGnIdnn/o6W35Ud/h8OtFGBBaEveS2eJxbr
        rupYu0FzchDCbeNj5DgPWHqnkmPMhuY=
X-Google-Smtp-Source: ABdhPJyEG72ZIP+OEzDnU04h7SmZ7QlNoIYoKlGCl8ApPmuDLKRuccSgYXHlK6rimVR2anRaxFBp0g==
X-Received: by 2002:a17:907:3e22:: with SMTP id hp34mr9004226ejc.491.1638983951207;
        Wed, 08 Dec 2021 09:19:11 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id ch28sm2293954edb.72.2021.12.08.09.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 09:19:10 -0800 (PST)
Date:   Wed, 8 Dec 2021 19:19:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208171909.3hvre5blb734ueyu@skbuf>
References: <20211207190730.3076-2-holger.brunck@hitachienergy.com>
 <20211207202733.56a0cf15@thinkpad>
 <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208162852.4d7361af@thinkpad>
 <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208171720.6a297011@thinkpad>
 <20211208172104.75e32a6b@thinkpad>
 <20211208164131.fy2h652sgyvhm7jx@skbuf>
 <20211208164932.6ojxt64j3v34477k@skbuf>
 <20211208180057.7fb10a17@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211208180057.7fb10a17@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 06:00:57PM +0100, Marek Behún wrote:
> > Also, maybe drop the "serdes-" prefix? The property will sit under a
> > SERDES lane node, so it would be a bit redundant?
> 
> Hmm. Holger's proposal adds the property into the port node, not SerDes
> lane node. mv88e6xxx does not define bindings for SerDes lane nodes
> (yet).

We need to be careful about that. You're saying that there chances of
there being a separate SERDES driver for mv88e6xxx in the future?
