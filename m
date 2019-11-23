Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E8E107BF8
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKWAT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:19:58 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33468 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWAT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:19:57 -0500
Received: by mail-lf1-f67.google.com with SMTP id d6so6847470lfc.0
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cCKUrCts2+t8rP0ScV3w0/Tj1cDEwboZDIJtSXZbwS8=;
        b=CQQTqlgmc9AoFm+WbiVEsoL41/6vqIC8qlytBOiVKqcRaJEpqoXoSrUx9732545WRK
         l0AhBUzKceVPXDCzFVDPLiotmWd6kTR/BfvUmJLcxHpp8pS6bgpuqiTIZ2EzY1NErkR+
         vI3feiJQbfeNzMR1UGjIY9KdmpD4x0vdBC1qjeEOWeVJKTWdZxsPVSQfn85sGcKwAblA
         K07cg6F69Z6xS6ePTAJdnCYzHF4QP56BWV6btedeMRMzR8BCQlHC+sNbGct+lur8tMX1
         YsVNjBMZAuLHvl0XxOlHC/Z0y/BtRegNHiAPnK8KksUMxB2L7BU7fFtXhnumcOlQsh8H
         ssIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cCKUrCts2+t8rP0ScV3w0/Tj1cDEwboZDIJtSXZbwS8=;
        b=iEiZ/CI03lYSi5oWxfesA+aXfWO3r7sH4m6EDJQMSTqtP6e2uqUOw7Z9JQBndfTwjm
         i111yCC5DoLQawIbGui+E3hIsMfOPOsajKM6caNd9Nv0PTdYR+une3jNqWFiqNKbBt8k
         UNbJYPRpMn0CiVcPzl3K/NjqC6tXjqQy0v/XngfSI2T9kHoWfHlZ62+pe7EcFM3JIPUr
         qmg0WCZ8dcLGOgZK8FDWlZRZuqpm0QQn75ZhCGREJuhup4pZV7KGl2HBWB0N2cCHKKmu
         CKGrKB+xrmp6R8WdmtKAqRRvMICBIwTwU6jbW7BN6tbFV+N22++6j8Su+NwJGK5absOf
         Fmlg==
X-Gm-Message-State: APjAAAVbEWTlq4dhh/RbmFQeY8jc6ttSRuDEsNc6PEuCPTrqkzyZ8d4z
        pp9s/EjkLpPwagVDIVR3kr1qRQ==
X-Google-Smtp-Source: APXvYqzRk5k+5bZduXWd5nA8ivMtcMNLquVWt86KVzCXYAC7TgtGJYSBoU9t+pXJSWiOgftB2j3rww==
X-Received: by 2002:a19:756:: with SMTP id 83mr11599176lfh.173.1574468394114;
        Fri, 22 Nov 2019 16:19:54 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x23sm3825648lfe.8.2019.11.22.16.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:19:53 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:19:45 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v2 1/3] cxgb4/chcr: update SGL DMA unmap for
 USO
Message-ID: <20191122161945.1086e58c@cakuba.netronome.com>
In-Reply-To: <20191122160629.3800b5cc@cakuba.netronome.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
        <6cf3a3928ff2ee84cca34bfcb61d3f7fcb4c4cac.1574383652.git.rahul.lakkireddy@chelsio.com>
        <20191122160629.3800b5cc@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 16:06:29 -0800, Jakub Kicinski wrote:
> > -struct tx_sw_desc;
> > +struct ulptx_sgl;  
> 
> From this patch alone the forward declaration of struct ulptx_sgl;
> appears unnecessary or a left over from some previous version of the
> code?

Okay, taking that back, looks like compiler treats use of struct type
in another struct as a forward declaration. Interesting.
