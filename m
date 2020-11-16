Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEE72B5567
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgKPXyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgKPXyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:54:09 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5E0C0613CF;
        Mon, 16 Nov 2020 15:54:08 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id o21so26926942ejb.3;
        Mon, 16 Nov 2020 15:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O+wYM2jAJjkb77hPO19vJ27xjqvanZ7EmWoujrPf3lc=;
        b=aPEzHKk9X0hDglJTpuSli/GpgNo6dOZ3ypGGuuQerBBJYoRDh6vujCn5TgkKzfgKmG
         14MTnGljjYVn5Rj38Zaggdbvo5ger6JitRhAsqU3J8DGcKsty2BEYkGw7exaozKVXapG
         zJqmeEGwyHKBhkYGH+CmSWVdhB49DT7tRVLf2XWaTtIt401GhcqwHMv/wo3MWGQ2dIMV
         uEXkHPAfvjhyZnS2J3W/+Mdcfhly5/IkJI5xSsvoxiWc+mGxdSr5X9g384Ayg5bKMMMO
         espFSAnYabsz/GJB0npjIR+egGbIIQf2RcyMEdc5B20QehnIQaOb0K5Qx9TbW2F66lDP
         nKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O+wYM2jAJjkb77hPO19vJ27xjqvanZ7EmWoujrPf3lc=;
        b=NRVlMYxZeeq9bs8M8bPT+1MghIsOwOZQc6vuzGcYho2NJcmSAAum2iGlHR6AWujB01
         yaeZU5vWqcBa410aaWganlofM/azQOzXVRcGPOcaS3aSOfhk2nywLkY3JbYM67Jab02o
         DgDyFkdNWS2HlqOeeJpQ248256CZwTnVhw/a7TbzhbVYUrsJLTjn+UeQu0iaLspjoARn
         adELynVJy2l5vLc1IQtv+QUM88/kKRL1pPOqgYpk+RMibFGXV5o24RXB8dOynYRRiJPT
         oyfWJnhNP+zyk4zfeDLQiXPgjBm5TR0eBDCm1/o746bLf5LcBzvIV3kfnsd6qGUnWcE/
         LYJQ==
X-Gm-Message-State: AOAM531pcCS3puaP84sBZxUrYBUAaMHxyZlZn0JyXm052zZ4265XeXqa
        pO7zph/nwdBkw8nX3EOMfiXKmd6C418=
X-Google-Smtp-Source: ABdhPJxPExAf7sk77l6mJg/slP8xbYPI6aFH0Q9ZYBLoDaWBLwjauMynGP5vQbhF/RDsg3wxoVfg0Q==
X-Received: by 2002:a17:906:d149:: with SMTP id br9mr4569672ejb.460.1605570847123;
        Mon, 16 Nov 2020 15:54:07 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id u9sm223725ejt.35.2020.11.16.15.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:54:06 -0800 (PST)
Date:   Tue, 17 Nov 2020 01:54:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201116235405.wkyyhqznocit4vj2@skbuf>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
 <20201019200258.jrtymxikwrijkvpq@skbuf>
 <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
 <20201019211916.j77jptfpryrhau4z@skbuf>
 <20201020181247.7e1c161b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a8d38b5b-ae85-b1a8-f139-ae75f7c01376@gmail.com>
 <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
 <20201116154710.20627867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116154710.20627867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 03:47:10PM -0800, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 15:20:37 -0800 Florian Fainelli wrote:
> > >> Florian for you patch specifially - can't we use
> > >> netdev_for_each_lower_dev()?  
> > > 
> > > Looks like I forgot to respond here, yes we could do that because we do
> > > call netdev_upper_dev_link() in net/dsa/slave.c. Let me re-post with
> > > that done.  
> > 
> > I remember now there was a reason for me to "open code" this, and this
> > is because since the patch is intended to be a bug fix, I wanted it to
> > be independent from: 2f1e8ea726e9 ("net: dsa: link interfaces with the
> > DSA master to get rid of lockdep warnings")
> > 
> > which we would be depending on and is only two-ish releases away. Let me
> > know if you prefer different fixes for different branches.
> 
> Ah, makes sense, we can apply this and then clean up in net-next. Just
> mention that in the commit message. FWIW you'll need to repost anyway
> once the discussion with Vladimir is resolved, because this is in the
> old patchwork instance :)

Yeah, I think Florian just wants netconsole to work in stable kernels,
which is a fair point. As for my 16-line patch that I suggested to him
in the initial reply, what do you think, would that be a "stable"
candidate? We would be introducing a fairly user-visible change
(removing one step that is mentioned as necessary in the documentation),
do you think it would benefit the users more to also have that behavior
change backported to all LTS kernels, or just keep it as something new
for v5.11? Either way, if it doesn't qualify as a patch for "stable",
then I guess Florian should just resubmit his patch on
net/core/netpoll.c.
