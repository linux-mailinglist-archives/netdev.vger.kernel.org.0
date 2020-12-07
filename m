Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E872D1957
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgLGTUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgLGTUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:20:19 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878B6C061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 11:19:39 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id z9so10238304qtn.4
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 11:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lq9hDm9k6diq4ASN1aKgCqNImsDjR6I6842Mn4KBJh8=;
        b=C2Yh8TSe9E48yCuLiX+RuoFuhOr8cMcyRM4J1LcRzcByQWX6cVtQ6AL7jEq+icmN/6
         7And4Jr3QeOOvYaMBmyIi9tNoBiWBdIf1f2wT435Wq8RJddNRBXA1DAB12qqRYc8pVW/
         2/KccuKRl8pAjn6V7rSlKen5b1NJv7lcfwIk44Ns++ttzjiQ0BtzJaKvs2I4l2paG4wt
         Wq1DbtzOTKV5Ev/mQpKV1efHeEAiOEG+TYQQp9wnwZtuv7vtsJD5xGQlZHyNyYLZKieG
         amRKh36mDBUcgPci4Fzbcm8oNsd0kFamNLjHKidGMW52uUnj+CmsrDrEp+xGOw279WMF
         CFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lq9hDm9k6diq4ASN1aKgCqNImsDjR6I6842Mn4KBJh8=;
        b=EEJ9OHpIaaUg8XzOs9/qu0nXMdw6fJ/XIuGxiUmJbA0larzoiiTtCY+jBhXXGYluFd
         cXDWFXlT5BBEyXNXfKWgCHgtCXVr+nqp+bACKTUgV34zapIzoQKSJIyjZjj+eEThPg96
         /379epZBu0Ite+wa3RpKKqLhNfVTXPz7PW+Lcjhl2+GrC2fOoKk/VwSnVaISjcBZu9gd
         Pwzw3k2XiI+ruvtSc7o5b02qPEVIhRfjDGxmr9ClJkQCxRfDpgMR7Zuc1HTLiHmgwzjG
         ZACe+EUCNzMXRFc+CIFq2l23ml+8y5DWT2fSekmznviwydzQ3mzalZ7fHyFxoLs4ebS3
         iROw==
X-Gm-Message-State: AOAM531HfZp8F6Po6oJ5wIP3/gpXbVWvnYGuRLXiS21XXdaw2T7LsXJ2
        qB1dnzECb88uzfVQWr5RokY=
X-Google-Smtp-Source: ABdhPJzdXsTU62a8zVfCNTOCzZFZh4sO1HwISPqXWw9CatgOL0qBtkI21GcB/gaOghPXHcZbkgre0A==
X-Received: by 2002:a05:622a:346:: with SMTP id r6mr25096503qtw.299.1607368778645;
        Mon, 07 Dec 2020 11:19:38 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:9185:ed2e:32e5:f088:ae74])
        by smtp.gmail.com with ESMTPSA id p24sm4599547qkh.73.2020.12.07.11.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 11:19:37 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 45303C56DB; Mon,  7 Dec 2020 16:19:35 -0300 (-03)
Date:   Mon, 7 Dec 2020 16:19:35 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Ariel Levkovich <lariel@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@nvidia.com>,
        mleitner@redhat.com
Subject: Re: [net-next V2 09/15] net/mlx5e: CT: Use the same counter for both
 directions
Message-ID: <20201207191935.GD2685@localhost.localdomain>
References: <20200923224824.67340-1-saeed@kernel.org>
 <20200923224824.67340-10-saeed@kernel.org>
 <20201127140128.GC3555@localhost.localdomain>
 <9b24cd270def8ea5432fc117e4fd1ed9c756a58d.camel@kernel.org>
 <e98a5a9d-9c65-9687-ca55-dcd266a6cfdf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98a5a9d-9c65-9687-ca55-dcd266a6cfdf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 12:20:54PM +0200, Oz Shlomo wrote:
> On 12/1/2020 11:41 PM, Saeed Mahameed wrote:
> > On Fri, 2020-11-27 at 11:01 -0300, Marcelo Ricardo Leitner wrote:
...
> > > The same is visible on 'ovs-appctl dpctl/dump-conntrack -s' then.
> > > Summing both directions in one like this is at least very misleading.
> > > Seems this change was motivated only by hw resources constrains. That
> > > said, I'm wondering, can this change be reverted somehow?
> > > 
> > >    Marcelo
> > 
> > Hi Marcelo, thanks for the report,
> > Sorry i am not familiar with this /procfs
> > Oz, Ariel, Roi, what is your take on this, it seems that we changed the
> > behavior of stats incorrectly.
> 
> Indeed we overlooked the CT accounting extension.
> We will submit a driver fix.

Cool. Thanks for confirming it, Oz.

  Marcelo
