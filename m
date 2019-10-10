Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C31D2240
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 10:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbfJJIHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:07:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34375 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733103AbfJJIHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:07:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id j11so6627612wrp.1
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 01:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y/Y1isfsR5QTsIDcCNMrcDVxUoMP5ntcNvmR1lPPJ7E=;
        b=NOANYE7IGzBvQCR6HMh1ZvHuYK9ehqglHTooU08THwJGMNtGgR5TosFC41FN6Rt2az
         riDwgn+01pBeXYD5U6LqSmQImBYjVdBudEdba7kofDKA4kCw+Qj9xx7t47cf94K5954y
         0Ig4DgcvOGYMFF1j7e/HSX/vxFtXtM+jnMjQFjZXtuW7Hr/Tb0AmQZQGmstuVWIo5tKv
         0FjxqoJrX1+rn/AnAey51hQkhO7UPzTS1b3s0JWoQvenjA6mfh31Tdy95ty55rCMRWTC
         qMuqUbsjv5u2z/oRuDB6KQ92MtV9oQyAsU0vXyNTFG7uPdKPCAOx88bpmERM5/o6nDAs
         CbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y/Y1isfsR5QTsIDcCNMrcDVxUoMP5ntcNvmR1lPPJ7E=;
        b=dHvRY4gMcYUpQ9Ttsk0HhrKrE3O9Drp6sSi60ofS8PrKUBZAJwFfSjfA0dnWzJsOff
         GGk/sARDGU+LGtAfQdtY2FYvHCiRcS9aszrap9pKhcfHK9BxamhyPGchKVZ/FHIiYlQJ
         ufd9YqNJWRnJKFqDPTOMPo8L157RZAJA/lJ4aZZuHD1cONGvxOkj1EjMe50xECn+senm
         KTncpGCU/Fqc+0E+cVqyS2/u5cnLvkpQnOfUS+B8Na/mYQV17jiqMoBkPeEWcffojNE/
         rpmvX1J9aGXR3LWsNp1rPiZua+QlSvg5D+U2ICgcpOI49JRmLP/88y75PAHDMcb3sEie
         m2ng==
X-Gm-Message-State: APjAAAVZ1dBHL0LkyHJu7UiwJ5Zco5Amd/wZmMVcvHG16Y2YVEYw/DKA
        SQ8HKVIJG5qe8huDsH6rVT1DWg==
X-Google-Smtp-Source: APXvYqwKl5JjUzMLAsJABCg79wW124z2hrBr5kIpjH3jjX6D7fN0BPEliVovek5LWvRkzyKFlsddnw==
X-Received: by 2002:a5d:4f87:: with SMTP id d7mr7569764wru.314.1570694825512;
        Thu, 10 Oct 2019 01:07:05 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id f18sm3450775wrv.38.2019.10.10.01.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:07:04 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:07:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ayal@mellanox.com,
        moshe@mellanox.com, eranbe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 2/4] devlink: propagate extack down to health
 reporter ops
Message-ID: <20191010080704.GB2223@nanopsycho>
References: <20191009110445.23237-1-jiri@resnulli.us>
 <20191009110445.23237-3-jiri@resnulli.us>
 <20191009203818.39424b5d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009203818.39424b5d@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 10, 2019 at 05:38:18AM CEST, jakub.kicinski@netronome.com wrote:
>On Wed,  9 Oct 2019 13:04:43 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> During health reporter operations, driver might want to fill-up
>> the extack message, so propagate extack down to the health reporter ops.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>I wonder how useful this is for non-testing :( We'd probably expect most
>health reporters to have auto-recovery on and therefore they won't be
>able to depend on that extack..

That is probably true. But still, what is harm of carrying potential
error message to the user?
