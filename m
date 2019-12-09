Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA9A116955
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 10:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfLIJaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 04:30:20 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:46196 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfLIJaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 04:30:20 -0500
Received: by mail-wr1-f51.google.com with SMTP id z7so15253813wrl.13
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 01:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5FYPf55A9QD3qfetiaCjzhJJooLi3U7Kd/RBhrelM9M=;
        b=c1Rnd+XQGBNotME74KjiU4zX22HAr3EN9YBK9s2JYMZqBur4yGWrOT6R13lXckompm
         BXK2RGLm1vJkA30xOAL8IggNDfIU7k1oH7ry+O1bBEmvK+SAjKCqbLPHvPZdnkbyAcKw
         0wUZgMP/422psl7x8PVEOAT61NNpyswfUBx2rL8l7lQF/oAvPGyVOmJgKW+rh3wQmzoU
         jw9kKU4sY9SzhzTTAZZAlTyMeZ0X92yCQeIMd8/c9aYCUICrWnwOomDb+M1sEA5PDBui
         OASpzYJSKkUwpQO0oecE8wF0TQGDqMSUrfn1kmRATQ9TEyQAgeh6QASQCPusYcEXko1F
         ZKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5FYPf55A9QD3qfetiaCjzhJJooLi3U7Kd/RBhrelM9M=;
        b=eIX2qHPDvITaIGE5zi9bBnaqMk8R+ibDVeyU/bxj1oZC/aVoSm/3fSenrz2rbwZl6w
         dEJOduf9jOryekj1kHjvw5gFwVLodj2HSSclp21xutpTzrPPGEMteFIi/GxkM1owfQle
         h73z86klbxH8djnEbkYGugQbP3V3nVYjRf1u3PKoEHaryyUW8gc2iaEApdK9BNg6smBv
         zPSjHkRvjb+VaBxVYb2O/dzHEtzUBDRUz/EHVnSHh3Gg4J2RxM0otFiSZRiGdC4m+yca
         okHKMPeQOXDH4JCWQBlTqPKATVE3zLDSfa/1Hv7f3eE6y5VfML10/S/yjp+qA4jFgUg3
         Tdaw==
X-Gm-Message-State: APjAAAWIi47GDwHp9+ly33wwRSvyLOuybja7dyn48win9HcSkgVdUBfc
        l9Z/8DmEvHPSmBfp3wBJ9YcgtQ==
X-Google-Smtp-Source: APXvYqx+kh6YOy2MP3D5/cS+JiFoVRa+yAv04cGY4T6AzXikAOzzb3GEfFFotIeg0I1nWJOVPyg6+Q==
X-Received: by 2002:adf:c746:: with SMTP id b6mr934717wrh.298.1575883818048;
        Mon, 09 Dec 2019 01:30:18 -0800 (PST)
Received: from apalos.home (athedsl-4476713.home.otenet.gr. [94.71.27.49])
        by smtp.gmail.com with ESMTPSA id w13sm27829342wru.38.2019.12.09.01.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 01:30:17 -0800 (PST)
Date:   Mon, 9 Dec 2019 11:30:14 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3Yy?= =?utf-8?Q?=5D?= page_pool:
 handle page recycle for NUMA_NO_NODE condition
Message-ID: <20191209093014.GA25360@apalos.home>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <e724cb64-776d-176e-f55b-3c328d7c5298@huawei.com>
 <96bc5e8351a54adc8f00c18a61e2555d@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96bc5e8351a54adc8f00c18a61e2555d@baidu.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:47:50AM +0000, Li,Rongqing wrote:
> > >
[...]
> > > Cc'ed Jesper, Ilias & Jonathan.
> > >
> > > I don't think it is correct to check that the page nid is same as
> > > numa_mem_id() if pool is NUMA_NO_NODE. In such case we should allow
> > > all pages to recycle, because you can't assume where pages are
> > > allocated from and where they are being handled.
> > >
> > > I suggest the following:
> > >
> > > return !page_pfmemalloc() &&
> > > ( page_to_nid(page) == pool->p.nid || pool->p.nid == NUMA_NO_NODE );
> > >
> > > 1) never recycle emergency pages, regardless of pool nid.
> > > 2) always recycle if pool is NUMA_NO_NODE.
> > 
> > As I can see, below are the cases that the pool->p.nid could be
> > NUMA_NO_NODE:
> > 
> > 1. kernel built with the CONFIG_NUMA being off.
> > 
> > 2. kernel built with the CONFIG_NUMA being on, but FW/BIOS dose not provide
> >    a valid node id through ACPI/DT, and it has the below cases:
> > 
> >    a). the hardware itself is single numa node system, so maybe it is valid
> >        to not provide a valid node for the device.
> >    b). the hardware itself is multi numa nodes system, and the FW/BIOS is
> >        broken that it does not provide a valid one.
> > 
> > 3. kernel built with the CONFIG_NUMA being on, and FW/BIOS dose provide a
> >    valid node id through ACPI/DT, but the driver does not pass the valid
> >    node id when calling page_pool_init().
> > 
> > I am not sure which case this patch is trying to fix, maybe Rongqing can help to
> > clarify.
> > 
> > For case 1 and case 2 (a), I suppose checking pool->p.nid being
> > NUMA_NO_NODE is enough.
> > 
> > For case 2 (b), There may be argument that it should be fixed in the BIOS/FW,
> > But it also can be argued that the numa_mem_id() checking has been done in
> > the driver that has not using page pool yet when deciding whether to do
> > recycling, see [1]. If I understanding correctly, recycling is normally done at the
> > NAPI pooling, which has the same affinity as the rx interrupt, and rx interrupt is
> > not changed very often. If it does change to different memory node, maybe it
> > makes sense not to recycle the old page belongs to old node?
> > 
> > 
> > For case 3, I am not sure if any driver is doing that, and if the page pool API
> > even allow that?
> > 
> 
> I think pool_page_reusable should support NUMA_NO_NODE no matter which cases
> 

Yes 

> 
> And recycling is normally done at the NAPI pooling, NUMA_NO_NODE hint to use the
> local node, except memory usage is unbalance, so I add the check that the page nid is
> same as numa_mem_id() if pool is NUMA_NO_NODE

I am not sure i am following here.
Recycling done at NAPI or not should have nothing to do with NUMA.
What do you mean by 'memory usage is unbalance'?


Thanks
/Ilias
