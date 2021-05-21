Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF138C826
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhEUNcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:32:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232172AbhEUNcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621603883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cR5IK4uYlCwIxbvJ3kOB0k2rfX+Xy625GK1RhbTRbeI=;
        b=gnWuMLF/ENXOa+t4nI31744aju9kC70RD+9iktce7uRh8K+h01AhGebHhIXaNDZDPEcdIF
        +0VcXqVBZhGTvcuaM6MXZAT1bIdy6QL0kF8xKM7uU6JNZB7mCOGwnH+tQOi6MvA7ByKDni
        FNug+seZC0nBiTntc2BiIt9DzcfL7hw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-Umrm2pLUOfOQKPmpWSLLUw-1; Fri, 21 May 2021 09:31:20 -0400
X-MC-Unique: Umrm2pLUOfOQKPmpWSLLUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99CC2108BD11;
        Fri, 21 May 2021 13:31:17 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32BC65C1BB;
        Fri, 21 May 2021 13:31:12 +0000 (UTC)
Date:   Fri, 21 May 2021 15:31:10 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "Zhang, Jessica" <jessica.zhang@intel.com>,
        "Kubiak, Marcin" <marcin.kubiak@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "Maloor, Kishen" <kishen.maloor@intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Swiatkowski, Michal" <michal.swiatkowski@intel.com>,
        "Plantykow, Marta A" <marta.a.plantykow@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Czapnik, Lukasz" <lukasz.czapnik@intel.com>, brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: AF_XDP metadata/hints
Message-ID: <20210521153110.207cb231@carbon>
In-Reply-To: <DM4PR11MB54224769926B06EE76635A6484299@DM4PR11MB5422.namprd11.prod.outlook.com>
References: <dc2c38cdccfa5eca925cfc9d59b0674e208c9c9d.camel@intel.com>
        <DM6PR11MB2780A8C5410ECB3C9700EAB5CA579@DM6PR11MB2780.namprd11.prod.outlook.com>
        <PH0PR11MB487034313697F395BB5BA3C5E4579@PH0PR11MB4870.namprd11.prod.outlook.com>
        <DM4PR11MB5422733A87913EFF8904C17184579@DM4PR11MB5422.namprd11.prod.outlook.com>
        <20210507131034.5a62ce56@carbon>
        <DM4PR11MB5422FE9618B3692D48FCE4EA84549@DM4PR11MB5422.namprd11.prod.outlook.com>
        <20210510185029.1ca6f872@carbon>
        <DM4PR11MB54227C25DFD4E882CB03BD3884539@DM4PR11MB5422.namprd11.prod.outlook.com>
        <20210512102546.5c098483@carbon>
        <DM4PR11MB542273C9D8BF63505DC6E21784519@DM4PR11MB5422.namprd11.prod.outlook.com>
        <7b347a985e590e2a422f837971b30bd83f9c7ac3.camel@nvidia.com>
        <DM4PR11MB5422762E82C0531B92BDF09A842B9@DM4PR11MB5422.namprd11.prod.outlook.com>
        <DM4PR11MB5422269F6113268172B9E26A842A9@DM4PR11MB5422.namprd11.prod.outlook.com>
        <DM4PR11MB54224769926B06EE76635A6484299@DM4PR11MB5422.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 May 2021 10:53:40 +0000
"Lobakin, Alexandr" <alexandr.lobakin@intel.com> wrote:

> I've opened two discussions at https://github.com/alobakin/linux,
> feel free to join them and/or create new ones to share your thoughts
> and concerns.

Thanks Alexandr for keeping the thread/subject alive.
 
I guess this is a new GitHub features "Discussions".  I've never used
that in a project before, lets see how this goes.  The usual approach
is discussions over email on netdev (Cc. netdev@vger.kernel.org).

Lets make it a bit easier to find these discussion threads:
 https://github.com/alobakin/linux/discussions

#1: Approach for generating metadata from HW descriptors #1
 https://github.com/alobakin/linux/discussions/1

#2: The idea of obtaining BTF directly from /sys/kernel/btf #2
 https://github.com/alobakin/linux/discussions/2

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

