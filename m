Return-Path: <netdev+bounces-11848-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE4C734D5C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E6D71C2084E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB9C6FCB;
	Mon, 19 Jun 2023 08:16:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BB46ABD
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:16:50 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47966FE
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:16:49 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f9b1a117caso3728865e9.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687162608; x=1689754608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=isW3ro7VrnYReL/xeasva9RHi55m+3Ng9iiYsqlf/a8=;
        b=KazX0yNwB3GD0qMpqNeT8B+fVx8dSsh+RVEMQxLTiOHuNIvFUyQeyxpRx3Yy0F/lDB
         iTsNhLrLZuuHpQchOMW4OtFPnuo015E457SqxkYiKNazt5XDygOCKUBJMn3RlRvE08AE
         kA2UXPdlcFOhNaYXt7qNJZFN+E+ABsXrUJq1nEGXadlWSDXOyIe57cVNyYRxn4lEV0UB
         kW/+kLw6v+mxDXcSRmYaPm4ZMd67OhVXu0A5xZq37PSh+L45hlgsHesiQqJvCRs5im5a
         j0k2wQq6y5oRty8BWTPO/UWFpybYgV0yBSc1R4Tvo/NdpcHmfEEeYRfom/LMRew+bTau
         nvrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687162608; x=1689754608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isW3ro7VrnYReL/xeasva9RHi55m+3Ng9iiYsqlf/a8=;
        b=NIUfnUVumcxzvv7KcXzgxuCWQR3TW3p+rzAsILx3HidlDS6nRkcHRBE0m8AMmKukQj
         0MzKfJbDKXqGYpb1xsRormk0r5A2xBpKRtDNWMJxKyg50fK+Tn3DmxuWWMQEFGFmAnYs
         m7BSv43fBRK3LKxv/xpnbyKrN4a1z5q68ETBmuDljyQhnzDA9X7JF2pFUyo4vWeWWVwT
         2npOJp44lT/cTgAqwUFIyNYtpLxevSUw+DLEoRA3zRpw4OckBE+e7IR8CDPbGY0kiNHV
         CN+BdMzPVPbKR3UgGxiaFsGt6A36bRkeDLJyXFHXInHqOVu7azVc/Cm5kUNnpLsab1OT
         u3GQ==
X-Gm-Message-State: AC+VfDwIXMm/FMlD9RAyH5Du6LB6MJyNpQRMKoiIh+DU/uM/Jyw8ruP9
	MP74ET27AnRxFntWnWJX3UOICQ==
X-Google-Smtp-Source: ACHHUZ7YdUPbrAC9vk9luum3Fiw2SRofBrawd9gnl7RQJA52PSeTUGT+mXUQecxLW0mDU/E7LRbnIA==
X-Received: by 2002:a5d:63c5:0:b0:30a:efd2:c170 with SMTP id c5-20020a5d63c5000000b0030aefd2c170mr5312318wrw.37.1687162607724;
        Mon, 19 Jun 2023 01:16:47 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id d6-20020adffd86000000b0030ae87bd3e3sm30749486wrr.18.2023.06.19.01.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 01:16:45 -0700 (PDT)
Date: Mon, 19 Jun 2023 11:16:42 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org, Boris Pismenny <boris.pismenny@gmail.com>
Subject: Re: [PATCH 4/4] net/tls: implement ->read_sock()
Message-ID: <635399d3-552f-460d-8bf3-19c039d03df2@kadam.mountain>
References: <20230614062212.73288-1-hare@suse.de>
 <20230614062212.73288-5-hare@suse.de>
 <ZI2+SDzKwK7i8Nw6@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZI2+SDzKwK7i8Nw6@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 17, 2023 at 04:08:08PM +0200, Simon Horman wrote:
> + Dan Carpenter
> 
> On Wed, Jun 14, 2023 at 08:22:12AM +0200, Hannes Reinecke wrote:
> 
> ...
> 
> > +
> > +read_sock_end:
> > +	return copied ? : err;
> 
> Hi Hannes,
> 
> I'm of two minds about raising this or not, but in any case here I am
> doing so.
> 
> Both gcc-12 [-Wmaybe-uninitialized] and Smatch warn that err may be
> used uninitialised on the line above.
> 
> My own analysis is that it cannot occur: I think it is always the case
> that either copied is non-zero or err is initialised.

Hm...  Yeah.  This is a bug in how Smatch handles:

	return copied ? : err;

Smatch wants every return to have a simple literal or variable.  So if
the return is complicated it gets changed into:

	fake_variable = copied ? : err;
	return fake_variable;

Smatch translates this to:

	if (!(fake_variable = copied))
		fake_variable = err;

[ Here fake_variable doesn't have side effects but under other
  circumstances this transformation could cause double evaluate side
  effects bugs.  So that's another bug in Smatch. ]

Then Smatch parses the fake_variable = copied condition as:

	fake_variable = copied;
	if (fake_variable) {

The problem is that the type of fake_variable is based on the type of
tls_sw_read_sock() so it is a 32bit while copied is a 64bit (of unknown
value).  So Smatch says, "Just because copied is non-zero doesn't mean
fake_variable is non-zero because the value might get truncated when
we cast away the high 32 bits."

This not a serious proposal but a just to demonstrate that this is
what happens there are two ways to silence this warning.  Changing the
type of tls_sw_read_sock() to long.  Or change the code to:

	if (copied)
		return copied;
	return err;

Probably the right thing is to create a second fake_copied variable
based on typeof(copied).

	fake_copied = copied;
	if (fake_copied)
		fake_return_variable = fake_copied;
	else
		fake_return_variable = err;

It's a doable thing.  Plus now there are no double evaluate side effects
bugs.  I have written this code and it silences the warning, but I'll
test it out tonight to see what breaks.

regards,
dan carpenter


