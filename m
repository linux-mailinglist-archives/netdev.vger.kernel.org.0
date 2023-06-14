Return-Path: <netdev+bounces-10828-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F45730626
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 148D11C20D6B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711F37F;
	Wed, 14 Jun 2023 17:38:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355AC2EC3B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA630C433CA;
	Wed, 14 Jun 2023 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686764334;
	bh=yR02GLqLTyIWX9U99iZ0NmxdvKpsBgaVyJ69Zs8coD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E+mqqpXDrfi0M5vMnMyDyCaP4VXNq5VjGypXXs4eNB/nF3EBHBxrSKnACgKw8tACV
	 bGSmC9YtfOeKezRJYRBHDUKFAI6MKLNrN38mpmDFp6LmrrdAhs6OWK8wNGVGqzPDww
	 jXnY5RwyBy3XLNuPl4CO+ktqjzVcBgjK+0Npg47EtHpKPTzNUmpEGJ8uT7bmUaDlK3
	 Kj949YVplhBwd95vrgIdkkdU/NxOLOJ/FoZlPuNz3GX+CHJ8Lt4AjilkqAOVJDncjt
	 KelZFaQwoq8sXgj9hQj4Hf7G2O87JSpnb4Lb1A6pjz+fIdV7/lDVxwf0nUYRkiB/Ow
	 MPj9kyHLTPo7A==
Date: Wed, 14 Jun 2023 10:38:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
 "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Subject: Re: [PATCH net-next] tools: ynl-gen: generate docs for
 <name>_max/_mask enums
Message-ID: <20230614103852.3eb7fd02@kernel.org>
In-Reply-To: <DM6PR11MB46570AEF7E10089E70CC1D019B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
	<20230613231709.150622-3-arkadiusz.kubalewski@intel.com>
	<20230613175928.4ea56833@kernel.org>
	<DM6PR11MB46570AEF7E10089E70CC1D019B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 12:48:14 +0000 Kubalewski, Arkadiusz wrote:
> >From: Jakub Kicinski <kuba@kernel.org>
> >Sent: Wednesday, June 14, 2023 2:59 AM
> >
> >On Wed, 14 Jun 2023 01:17:09 +0200 Arkadiusz Kubalewski wrote:  
> >> Including ynl generated uapi header files into source kerneldocs
> >> (rst files in Documentation/) produces warnings during documentation
> >> builds (i.e. make htmldocs)
> >>
> >> Prevent warnings by generating also description for enums where
> >> rander_max was selected.  
> >
> >Do you reckon that documenting the meta-values makes sense, or should
> >we throw a:
> >
> >/* private: */
> >  
> 
> Most probably it doesn't..
> Tried this:
> /*
>  [ other values description ]
>  * private:
>  * @__<NAME>_MAX
>  */
> and this:
> /*
>  [ other values description ]
>  * private: @__<NAME>_MAX
>  */
> 
> Both are not working as we would expect.
> 
> Do you mean to have double comments for enums? like:
> /*
>  [ other values description ]
>  */
> /*
>  * private:
>  * @__<NAME>_MAX
>  */
>
> >comment in front of them so that kdoc ignores them? Does user space
> >have any use for those? If we want to document them...
> 
> Hmm, do you recall where I can find proper format of such ignore enum comment
> for kdoc generation?
> Or maybe we need to also submit patch to some kdoc build process to actually
> change the current behavior?

It's explained in the kdoc documentation :(
https://docs.kernel.org/doc-guide/kernel-doc.html#members

