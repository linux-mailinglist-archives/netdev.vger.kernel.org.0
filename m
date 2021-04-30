Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8E1370067
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhD3SXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3SXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:23:35 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D985BC06174A;
        Fri, 30 Apr 2021 11:22:46 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id o27so2794440qkj.9;
        Fri, 30 Apr 2021 11:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pO4WyCI7L+HylreCdCSUwmGNqXA8ms97nyfShddenPk=;
        b=BWssw5nLYaDqjgQ8pCuDpp6JdHAFJUHs/5Omh8KDdE75h5wW4P4u9B1A41IECeoNg1
         RqCrj3nxm6ymW9m5Lq+jDd+0BzyZwGW7piwQzziQgmSdRUzX1VgAFOrle8I9w0eCcAue
         7+tfRZJqKYHsQ3FkQY82mi4QRkYXoxkp6eOnieC6Qp+C07NUZpSCULe0g3v9Qjx1AAN4
         Iu+oyNWOBmT7M3SNtS4XM5s/Z3tXhoWTyuMoxkbpzlHR+rvJDjg9qWc9XPOBvc9fRgKN
         gqrLx4Z8Zm4bX1osUpmffs585cfOZqqr9reJ2GJ32eQcm8DbMJJQb9GY0NpF5shjGvR7
         IeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pO4WyCI7L+HylreCdCSUwmGNqXA8ms97nyfShddenPk=;
        b=rKkXrcLiDiOux7U5ri4Ga1X6d6CTXcoiW9uXnk/gNo/JHsQ5UhI0+ctTZaNkA/nAYc
         Y0oXp9fA0nhw35bIKKozpwvuxFi9ANrDguLCCf0syIHBpvqOJvcDnWn57iIXHabgo+Ll
         ZsDo1/jjjh5TwP8UBo2KU8iMt4icd5IegdE8WqWELlkYKH8zAqMCchxdwFQ9er7XLkcH
         KxEfgQtm7SitH/J8aq0U79h0QbLKPMurl1PKX5JZr6bIFiwH24sVQ7TeorrRiqxy8Aap
         IIcoG3AiqNQH/YN4jzARndsfIxsmxQGSFkG/zKbPne8vuvgLw/z/iINmeKSTOhZ5ztaf
         8R1A==
X-Gm-Message-State: AOAM533avHHw7uAb59ZIyaJQUyw+39iUXAeSG45NKuW5PQLiU62XAGaP
        Ca9Rc3vmzRJs3jOx/BpS0p8=
X-Google-Smtp-Source: ABdhPJxjgLHvmhl0db7yfrhs9qcNgdB1Pf8HT4ViItJDcH6IEoTe8zt24oG69N4M6JXkC/i5/ooVcA==
X-Received: by 2002:a37:c57:: with SMTP id 84mr6919409qkm.340.1619806966092;
        Fri, 30 Apr 2021 11:22:46 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:14fb:c088:46f:2a8:ad2])
        by smtp.gmail.com with ESMTPSA id u64sm2093652qkc.127.2021.04.30.11.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 11:22:45 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 6C25CC07AE; Fri, 30 Apr 2021 15:22:43 -0300 (-03)
Date:   Fri, 30 Apr 2021 15:22:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: Re: [PATCH net 0/3] sctp: always send a chunk with the asoc that it
 belongs to
Message-ID: <YIxK8wOflRb7wzF+@horizon.localdomain>
References: <cover.1619806333.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1619806333.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 01, 2021 at 02:15:54AM +0800, Xin Long wrote:
> Currently when processing a duplicate COOKIE-ECHO chunk, a new temp
> asoc would be created, then it creates the chunks with the new asoc.
> However, later on it uses the old asoc to send these chunks, which
> has caused quite a few issues.
> 
> This patchset is to fix this and make sure that the COOKIE-ACK and
> SHUTDOWN chunks are created with the same asoc that will be used to
> send them out.
> 
> Xin Long (3):
>   sctp: do asoc update earlier in sctp_sf_do_dupcook_a
>   Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"
>   sctp: do asoc update earlier in sctp_sf_do_dupcook_b

Thanks folks.
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
