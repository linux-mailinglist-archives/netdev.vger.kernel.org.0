Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06591F172A
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 13:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgFHLBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 07:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729425AbgFHLBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 07:01:45 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FE7C08C5C2;
        Mon,  8 Jun 2020 04:01:45 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o8so8580939pgm.7;
        Mon, 08 Jun 2020 04:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l1OyezJKsfAVEn8ZVy6btGksNrrO6qZZSqmY/a2YBUc=;
        b=sHYjPvNZ05Y/2voOPYUDydKiKVm3AEujp2Am7yigeXijOCK3nHmkUB9ETSi50Frpze
         /1NIcSkfY4GZn01Aj1nlxUBBiGS4yaAaR8VcYZXt90tqadFm7EfQV294OlKIBjNfKwNY
         PAncwq0xfIcsWUJh2PaFx6Jzcgk9SI8DHFg9gltk/Qg2hHQ1Db8uRlbc95AVyFK6APst
         ZXWrfeW3F3QqZE0/kN0Wqu4wwTDcaGe4pYbQ9EidQ2J6H6NEfxZmbUH5DZKhZ6lDl0oa
         wH7xpxM2LE/lDFILbY600U9PCCjyfNb4ZOPDSltM2sEify+sLdNG18pZxLxBvJ7Bm6Rv
         CClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l1OyezJKsfAVEn8ZVy6btGksNrrO6qZZSqmY/a2YBUc=;
        b=C0yg4oeiuN8qa1yHOCnDTZJoo8zG13CKqmnewrcL6LJNbihyBJUJmeCqBCFbfnOTCp
         tBH/8o145DC0pULINVkz+zokywcgEF2fT57gTBKYpUiZLc4t6yX05bZXb4OxyRr0K4RQ
         uKA1NDHPoPFqInWVmQsynuirhjbC0DXMNvABR6KAJsQiPUlce6oBTGYxcuO026DUKuAm
         ZteswtVI9jSFNm6FRGYspYClCUjwUBfkAOuuPT/6xAZlQ6DO/yXnx2PSWNhCB12njKmi
         caFOl5qP8MppHm+9l1htr0RgDgsf0wz4TXKpLdN7v5n/gg+VRdhTalS7p6A0MIq4sBep
         lsVw==
X-Gm-Message-State: AOAM533dzhJZXRnsAi0Dpj6shZHSyUaSqUrmGyvcfZKa4N5TFDHvUbse
        uQLCzd95JxktxeU9cQ3ePgE=
X-Google-Smtp-Source: ABdhPJxCYt/AwRjjLIaHsFCJMLRDxuD9W2rADpDuuZ96/9B4/FmnLmax2ISPRgxvEnwAR0LixiqoCw==
X-Received: by 2002:a63:1312:: with SMTP id i18mr20063902pgl.142.1591614104413;
        Mon, 08 Jun 2020 04:01:44 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id m9sm6957125pfo.200.2020.06.08.04.01.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2020 04:01:43 -0700 (PDT)
Date:   Mon, 8 Jun 2020 18:59:29 +0800
From:   Geliang Tang <geliangtang@gmail.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: bugfix for RM_ADDR option parsing
Message-ID: <20200608105929.GA24487@OptiPlex>
References: <904e4ae90b94d679d9877d3c48bd277cb9b39f5f.1591601587.git.geliangtang@gmail.com>
 <41246875-febc-e88d-304b-2a6692f590ac@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41246875-febc-e88d-304b-2a6692f590ac@tessares.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 12:10:23PM +0200, Matthieu Baerts wrote:
> Hi Geliang,
> 
> On 08/06/2020 09:48, Geliang Tang wrote:
> > In MPTCPOPT_RM_ADDR option parsing, the pointer "ptr" pointed to the
> > "Subtype" octet, the pointer "ptr+1" pointed to the "Address ID" octet:
> > 
> >    +-------+-------+---------------+
> >    |Subtype|(resvd)|   Address ID  |
> >    +-------+-------+---------------+
> >    |               |
> >   ptr            ptr+1
> > 
> > We should set mp_opt->rm_id to the value of "ptr+1", not "ptr". This patch
> > will fix this bug.
> 
> Thank you for the patch, good catch!
> Indeed "ptr" should be incremented.
> 
> Because this is a bug-fix for net, may you clearly indicate that in the
> subject to help -net maintainers please? [PATCH net v2]
> 
> Also, may you add a "Fixes" tag as well as it is for -net ? I guess it
> should be:
> 
>     Fixes: 3df523ab582c ("mptcp: Add ADD_ADDR handling")
> 
> The rest is good!
> 
> Cheers,
> Matt
> -- 
> Matthieu Baerts | R&D Engineer
> matthieu.baerts@tessares.net
> Tessares SA | Hybrid Access Solutions
> www.tessares.net
> 1 Avenue Jean Monnet, 1348 Louvain-la-Neuve, Belgium

Hi Matt,

Thanks for your reply.

I have already resend patch v2 to you.

-Geliang
