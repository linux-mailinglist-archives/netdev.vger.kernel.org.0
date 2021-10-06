Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767CF423AE4
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhJFJvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:51:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237637AbhJFJve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 05:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633513782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FgeoNjrZHSkunXJ66ISQlY0LCPhrui/OmtiTa8trj+4=;
        b=PiJKHm3V3OeFbYXzCZSWvjpevOsJlyGmYkUXIgvxLtkEIMKhX1PqPAETZQae013P4gNdq2
        lZhhFId950OxDb4O6YZ4pNXv3AqI1LpA6ShDXCY3kZxEE/rknwA0F2oHQ8SGjMw6WfaEvP
        ZC/96Hwr6wu5ntAdvfpgpb0wTFPbS1Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-K6vKNbS7PlOe1TN7slzXeQ-1; Wed, 06 Oct 2021 05:49:41 -0400
X-MC-Unique: K6vKNbS7PlOe1TN7slzXeQ-1
Received: by mail-wr1-f70.google.com with SMTP id r16-20020adfb1d0000000b00160bf8972ceso1560841wra.13
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 02:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FgeoNjrZHSkunXJ66ISQlY0LCPhrui/OmtiTa8trj+4=;
        b=bLx2A4ifFcD+n07KYnokL1NtDGm7/UQrb6uWohJrwRmlBh3sE4duL6/KK05EeJaATE
         eFsfpNKTFHKrRKWtxE2k8DgUDJj96Fq0WlNkakTASm7KAonoBaNYlBj9Arm1fFV8RYPM
         p+uPoJec0QSZiwAlxasIOsVcggth1HrjY0HyM2aLHgJjgNm/64UmOe9jt03jbKexzlEb
         Vm+tQhyzJbZ1Wr9/YixExbqNUFoqNThZh7YGqsiEyJvCARPbnxeuiQ789U3yOA/um4ZJ
         5HOm4+Qp3+QkfBVDF+5i7vOYvoRwjIt5/huf+W2A6HT4dwvtnial1aYFfouIVLb5BGYs
         IO7g==
X-Gm-Message-State: AOAM532DHEF5sDIdom3qnlbNs/xZVF4SQoSFHbgsMtE6v9kJ2lFj3weN
        UJ9UoVL08XcpxmrYPKVXQOwSMTXQcYWhD7ZhzUpSqi1cLXJJ9vO+9AonqgsMFevfWieI1mlq0jE
        Va5bAi1yBYzzaMYFx
X-Received: by 2002:a5d:6dad:: with SMTP id u13mr27032195wrs.55.1633513779935;
        Wed, 06 Oct 2021 02:49:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOYC2xJ0L5NHN6c0W9jNfd4TLW31cQg/5u9qtlYzUhoBCNqEOF6mDguwCktGGT6KJi10Algg==
X-Received: by 2002:a5d:6dad:: with SMTP id u13mr27032171wrs.55.1633513779722;
        Wed, 06 Oct 2021 02:49:39 -0700 (PDT)
Received: from localhost ([37.161.37.11])
        by smtp.gmail.com with ESMTPSA id n11sm5150342wmq.19.2021.10.06.02.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:49:39 -0700 (PDT)
Date:   Wed, 6 Oct 2021 11:49:34 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: Re: [PATCH iproute2 v3 1/3] configure: support --param=value style
Message-ID: <YV1xLsQsADEhrJPz@renaissance-vector>
References: <cover.1633455436.git.aclaudi@redhat.com>
 <caa9b65bef41acd51d45e45e1a158edb1eeefe7d.1633455436.git.aclaudi@redhat.com>
 <20211006080944.GA32194@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006080944.GA32194@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 10:09:44AM +0200, Phil Sutter wrote:
> Hi Andrea,
> 
> A remark regarding coding style:
> 

Hi Phil,
Thanks for your review.

> On Wed, Oct 06, 2021 at 12:08:04AM +0200, Andrea Claudi wrote:
> [...]
> > diff --git a/configure b/configure
> > index 7f4f3bd9..d57ce0f8 100755
> > --- a/configure
> > +++ b/configure
> > @@ -501,18 +501,30 @@ if [ $# -eq 1 ] && [ "$(echo $1 | cut -c 1)" != '-' ]; then
> >  else
> >  	while true; do
> >  		case "$1" in
> > -			--include_dir)
> > -				INCLUDE=$2
> > -				shift 2 ;;
> > -			--libbpf_dir)
> > -				LIBBPF_DIR="$2"
> > -				shift 2 ;;
> > -			--libbpf_force)
> > -				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
> > +			--include_dir | --include_dir=*)
> 
> So here the code combines the two cases,
> 
> > +				INCLUDE="${1#*=}"
> > +				if [ "$INCLUDE" == "--include_dir" ]; then
> 
> just to fiddle it apart again. Did you consider leaving the old cases in
> place and adding separate ones for the --opt=val cases like so:
> 
> | 			--include_dir=*)
> | 				INCLUDE="${1#*=}"
> | 				shift
> | 				;;
> 
> [...]

That was my first proposal in v1 [1]. I changed it on David's suggestion
to consolidate the two cases into a single one.

Looking at the resulting code, v3 code results in an extra check to
discriminate between the two use cases, while v0 uses the "case"
structure to the same end.

> > +			--libbpf_force | --libbpf_force=*)
> > +				LIBBPF_FORCE="${1#*=}"
> > +				if [ "$LIBBPF_FORCE" == "--libbpf_force" ]; then
> > +					LIBBPF_FORCE="$2"
> > +					shift
> > +				fi
> > +				if [ "$LIBBPF_FORCE" != 'on' ] && [ "$LIBBPF_FORCE" != 'off' ]; then
> 
> To avoid duplication here, I would move semantic checks into a second
> step. This would allow for things like:
> 
> | --libbpf_force=invalid --libbpf_force=on
> 
> but separating the syntactic parsing from semantic checks might be
> beneficial by itself, too.

Yes, I agree with you. David, does this answer to your concern about v1?
If yes, I would proceed with a v4 integrating Phil's suggestions.

> 
> Cheers, Phil
>

[1] https://lore.kernel.org/netdev/cover.1633191885.git.aclaudi@redhat.com/

