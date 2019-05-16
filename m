Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799D820AF3
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 17:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfEPPTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 11:19:49 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38451 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfEPPTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 11:19:48 -0400
Received: by mail-qt1-f196.google.com with SMTP id d13so4342838qth.5
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 08:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KK3Pd8lOysuRFXC3TKFpzSjVytnncVCclOV4UYrlRT8=;
        b=eXI40U3U+bO6qCq85gJZF6MMaSQQYqjHq4A0LzLJ1JM2eyk0qhepE5PBXyemPITfwp
         Y3tnuYlFP4bNZ1S+cckn5Xr0Z9nRf5LpP3BXhedcXxVxLNU51eiwrg500wB8E11A7r5Q
         lnNrbMPfFWzgGspXUkLVHHzokkCr/9XXLu1W55hl6qATIyPKaG/TE8AVCC/kJPfm+lxd
         cAWYq9V5YUdtsf+M0Pc+KbFf6m2gx5OcNKbLshqacpYmZuFVeVH+L37MqWZO/cQ3b/qK
         Aw+dElTdDaTQRxY0cyzsxNsZFiBPXrCeClET6EI7qpj4DeV39M+3+I3zHPkYdv7sBuWu
         wjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KK3Pd8lOysuRFXC3TKFpzSjVytnncVCclOV4UYrlRT8=;
        b=ZSk5hr6PgpeZHWigqV5KZeRwo9H57TPbu6wnUNAklC5YVJU1Pf7aPfjnRbMgMLOS3w
         ltXqEWC+OaaAHCp3OglBr/EivxP+U4DxK+sZ+sRpaIBWlienAL4OBjcTYt2SJ0zyXb1P
         F8yt2yrpS875TgaT6oCY/iqGJQr6DrirRUW8CF5BNY/b/8HSMkCoyiATu5D5zYVr+EMT
         sYgEKbetRX7GcQkWxt7vLqJwGgQrC3L30UGv8BPY52L/UYNmEbnih64hyFt/yT9jTfWv
         y2qXL1DplAFyEVZlmoAiI2pTFXG9bKNPlT8+05mLsArsqB/CjcogHN/nqJoVzOSJipgY
         fjsg==
X-Gm-Message-State: APjAAAU3SxaSb0M23bE4Vi1r9SLzxPliZPCYJWJMz/pikKN9yIA7VNmb
        ZE7crsAL8JWxsoEzZQFVIig/HQ==
X-Google-Smtp-Source: APXvYqxMzEpz+dsRmYo1K3zLULjYp9FbmuSOcLO4o4ee1c3loTLiMT2uNgp/9yjfucjVIeXx9hQIGA==
X-Received: by 2002:a0c:878e:: with SMTP id 14mr41612347qvj.103.1558019987852;
        Thu, 16 May 2019 08:19:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x47sm3295469qth.68.2019.05.16.08.19.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 08:19:47 -0700 (PDT)
Date:   Thu, 16 May 2019 08:19:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, tgraf@suug.ch, netdev@vger.kernel.org,
        oss-drivers@netronome.com, neilb@suse.com,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] rhashtable: fix sparse RCU warnings on bit lock in
 bucket pointer
Message-ID: <20190516081921.75f9d9af@cakuba.netronome.com>
In-Reply-To: <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
References: <20190515205501.17810-1-jakub.kicinski@netronome.com>
        <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 13:16:23 +0800, Herbert Xu wrote:
> On Wed, May 15, 2019 at 01:55:01PM -0700, Jakub Kicinski wrote:
> > Since the bit_spin_lock() operations don't actually dereference
> > the pointer, it's fine to forcefully drop the RCU annotation.
> > This fixes 7 sparse warnings per include site.
> > 
> > Fixes: 8f0db018006a ("rhashtable: use bit_spin_locks to protect hash bucket.")
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>  
> 
> I don't think this is the right fix.  We should remove the __rcu
> marker from the opaque type rhash_lock_head since it cannot be
> directly dereferenced.
> 
> I'm working on a fix to this.

Make sense, anything that clears the warnings is fine with me :)

Thanks!
