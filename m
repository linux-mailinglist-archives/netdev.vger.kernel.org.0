Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABF5267E71
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 09:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgIMHti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 03:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgIMHtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 03:49:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38DAC061573;
        Sun, 13 Sep 2020 00:49:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so3761674pjr.3;
        Sun, 13 Sep 2020 00:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qYWzNSDa14AkONpbTTLew5leaH4VXQTqzaEvTUMECKw=;
        b=W2JxUspOxdm0NdXZ7vuXab7dorsL2Sg17rUePYjKC2jnCwKuKF+g0y1vMMFbTrCoA9
         Xl39Q8kyYLehH7wicKKkYhr8rfHlpYqUEHVaosiAzZLmoier6jxBcb6YSlUmYclTegUG
         +guaLxL/6oEVPr4dIcNW2hmyngJcVBn66iu+AWQjspCB1p0DLDe0NIDCU9fKdc0i++PL
         pCG0EYRjRu3GkUKjMnWPDme+xqMRidS6vnvk5wqOXStRF9exEgJVrqhC2PnlLshSVIO6
         ufPaXTwJW44MPjHkhesGk61Edw9kIe2xTTqYekoW85OJTJx0ipxTHmCW7ycmY2GpQfUr
         MV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qYWzNSDa14AkONpbTTLew5leaH4VXQTqzaEvTUMECKw=;
        b=MFDcSgOXMtgnmFVdoqtdpSJltXOs9/JunvWuvMPObDzUt4BxKlh7iYkClt+0CJWKCH
         CGmAjHeAN1znvs0Gs+bYhxMHjIHcS7o5X429OJh6sXUGRSoOwOOLkSsMnpQf7w9tZwG+
         /lIHe8EFdfXQufRdomADyesBW3qB2xmonAYUlDoYZlCs4UNYgpKkl2pJomkulEoywbmq
         xNX2fZ7rIUJP5h1AW4JtXOo27T2iVuaXxqJZtBiIMCHwT5/OJUVOwfjuZw5Dk7Nsow6Z
         6QScL6t4VqKcCJdAqak+PstYdMVOqRVINtRJ+SotehXRFUpAed8HjybBmKbEHd3edC58
         Q66w==
X-Gm-Message-State: AOAM530Hu0lgjK3ZIQ97qlPfGzcwy1/otdxMNMNWSr4kheeFWzL8cXUh
        wJUqLcQeloJmUmYZ9YZV8Q==
X-Google-Smtp-Source: ABdhPJwMctwccCvazig0Cn3qhtL8QflPk2h8eWljuT5ukI9082bAYzzDMWgC6b1Mb9SoIsvbMBTOCA==
X-Received: by 2002:a17:902:c692:b029:d0:90a3:24f4 with SMTP id r18-20020a170902c692b02900d090a324f4mr9256031plx.12.1599983375416;
        Sun, 13 Sep 2020 00:49:35 -0700 (PDT)
Received: from PWN (n11212042027.netvigator.com. [112.120.42.27])
        by smtp.gmail.com with ESMTPSA id s8sm632246pjm.7.2020.09.13.00.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 00:49:34 -0700 (PDT)
Date:   Sun, 13 Sep 2020 03:49:23 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        hdanton@sina.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] tipc: Fix memory leak in
 tipc_group_create_member()
Message-ID: <20200913074923.GA1533160@PWN>
References: <000000000000879057058f193fb5@google.com>
 <20200912102230.1529402-1-yepeilin.cs@gmail.com>
 <20200912.182336.585362420502143240.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912.182336.585362420502143240.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 12, 2020 at 06:23:36PM -0700, David Miller wrote:
> From: Peilin Ye <yepeilin.cs@gmail.com>
> Date: Sat, 12 Sep 2020 06:22:30 -0400
> 
> > @@ -291,10 +291,11 @@ static void tipc_group_add_to_tree(struct tipc_group *grp,
> >  		else if (key > nkey)
> >  			n = &(*n)->rb_right;
> >  		else
> > -			return;
> > +			return -1;
> 
> Use a real error code like "-EEXIST", thank you.

Ah, I'll fix it in v2 soon, sorry about that. I saw another function in
this file returning -1.

Peilin Ye
