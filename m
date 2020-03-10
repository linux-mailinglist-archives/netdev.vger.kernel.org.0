Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C834180293
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCJP4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:56:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55366 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726508AbgCJP4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583855796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mFuZQ7jFyv+GeNM1aKh/En77i64bZZln/pVw8fa9bqY=;
        b=MLmYmO1OiZt392z6rKxo7nUMDWlx1hifDhngL0YAiHbejXnI1DEx5qenlQwygXlXiydCoA
        IQVxeJMVgPvP8RRdLjaEvqAGRy+lucHsRtbf1n/rkJSkSUuQclIRcDiMR/X/HPUENHmgds
        hpjQ0UnNQi+MX7YEDOCJ+Bho3CghCEU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-_j-Mf_wgOaG1rqbR4aTjMA-1; Tue, 10 Mar 2020 11:56:33 -0400
X-MC-Unique: _j-Mf_wgOaG1rqbR4aTjMA-1
Received: by mail-wm1-f72.google.com with SMTP id f207so548886wme.6
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mFuZQ7jFyv+GeNM1aKh/En77i64bZZln/pVw8fa9bqY=;
        b=alMKT5bnKdVIgwiK8nWNM9ZyRNz5rNi4o6D8YC4scxPqOIjBUXEC6Clmr5rc2aKXu5
         dlocH1RT1JtHAjj600P8dceV4uDybGyC89sfZ9Etuc3czuwSNaptloiP+K9gmmL5p/A4
         LlOQoPogsv51JhQFIbhsYNbiLGzS/LtHnfngHHdQ02tx5MMAacVgRjCUiC5s6B6LXG7N
         Cd1N0IBO/gm1IDNJp4HHP46W79V1XoWlcbh6yk6GoL/RfnWIVgw1xQdcRhtDNZjJBXQO
         psGoY7Q2kDHv1d64o5rjWCUonW1xb3wJuYuvgLAf0ownyl58dsUsvfchHYC+wfjDM1cH
         wSuA==
X-Gm-Message-State: ANhLgQ0F5AJNs7Ibghc+fpCqYGdPTb5QY5CdVXuIH5Cl6++7pYtvVoVq
        oRjtLIZ/EUySc9iL6jakHZa/HQGPB0CJ21XncLNBk6N59qbnPGu43+7a+tDt8p+onVYWn0y5CzL
        /YD06Dowi4Pm1HDmn
X-Received: by 2002:a05:600c:280b:: with SMTP id m11mr2808609wmb.93.1583855792780;
        Tue, 10 Mar 2020 08:56:32 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvosUl0Z+fmxrZY7c6Y236yOBJg4NO40GCQ4VJSVF/FMa7sKow4MTwQ7piX+1qUcfsTV99X0A==
X-Received: by 2002:a05:600c:280b:: with SMTP id m11mr2808594wmb.93.1583855792528;
        Tue, 10 Mar 2020 08:56:32 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id k5sm2251254wmj.18.2020.03.10.08.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:56:31 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:56:30 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, mmhatre@redhat.com,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>
Subject: Re: route: an issue caused by local and main table's merge
Message-ID: <20200310155630.GA7102@pc-3.home>
References: <CADvbK_evghCnfNkePFkkLbaamXPaCOu-mSsSDKXuGSt65DSivw@mail.gmail.com>
 <1441d64c-c334-8c54-39e8-7a06a530089d@gmail.com>
 <CAKgT0UcbycqgrfviqUmvS9S7+F6q-gMzrz-KKQuEb77ruZZLRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcbycqgrfviqUmvS9S7+F6q-gMzrz-KKQuEb77ruZZLRQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 08:53:53AM -0700, Alexander Duyck wrote:
> Also, is it really a valid configuration to have the same address
> configured as both a broadcast and unicast address? I couldn't find
> anything that said it wasn't, but at the same time I haven't found
> anything saying it is an acceptable practice to configure an IP
> address as both a broadcast and unicast destination. Everything I saw
> seemed to imply that a subnet should be at least a /30 to guarantee a
> pair of IPs and support for broadcast addresses with all 1's and 0 for
> the host identifier. As such 192.168.122.1 would never really be a
> valid broadcast address since it implies a /31 subnet mask.
> 
RFC 3031 explicitly allows /31 subnets for point to point links. Also,
I've seen such network configurations in production on Linux boxes.

