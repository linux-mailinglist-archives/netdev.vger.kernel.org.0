Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A729E3DEF7C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhHCOAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbhHCN77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 09:59:59 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83082C061764;
        Tue,  3 Aug 2021 06:59:47 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i10so23851863pla.3;
        Tue, 03 Aug 2021 06:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4mFsdkxp6Aw6HFL87VLjwezm1Sz+I3cKph9vTTCvyyM=;
        b=ntfzF+nANifsLT5sfp87BIaEvIpgEe15cxmGFpkThesuhzjxH7cPBu7btukVF6lmAX
         ENBCPugujh976tUFETdlEMklBjwjs5WjEfYFqynyw5Z020A8b3g8SYcoHyv9MZU8BrU0
         OqGJXMOM/U8Ci585j+fnVb4tIiCZL+0JOoRj9tkofPDlR55OQzeDqYQgB+bUSjqpi+Fp
         AEjntO6dyvA0jIKG2VwEF/w0tlXgEfIN5Gl/5FvHLb7j0sqRvEbnqq9r2//HpZUSYqt/
         K5R1crrYK7w0dxkk9zTV65MJgLciMkARXQ3HWxGKW5wqcyTHOMMr+1Gpou9RlJEr8lfj
         FqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4mFsdkxp6Aw6HFL87VLjwezm1Sz+I3cKph9vTTCvyyM=;
        b=JvWJ0nixRlrpx6RDHucyPGMEZc7dnAKxF+XVBMAmetxlWHT6XkZTBydS6dehF6PDps
         i8/YVkOYPA56aJwiSyv0hUCb0V0jmlFPm79fFmjo2PpODCCGKRf5pDAupKdtXF3pQCyx
         Cifoacw5rUv7+fsraPat/pd4Eqw72nCBQLssyeWfNuQtzw6wj70p/N9ibSKoKD+fjKuU
         tY/Ptd/QNz8Orh8MipQ/aCAv7KWbTWuTD6cPFMxf4H5Sya1dkQOgUn4uqcJNSxx/fFlY
         FKJ8sfK2Z2DnPQvflhpmbOaGQimbl1/JsMuNFWnk2Ikstuv/ZldPRZSUdkeQ1KqHcLBm
         gmIA==
X-Gm-Message-State: AOAM5317L5yNrj81QwK5YKXQ2tFX31Sv/4MnFA9+ipUEHLhsgKDOSEyi
        EXv6PbPvTm5apKpPqVJH0Kc=
X-Google-Smtp-Source: ABdhPJyFBgHK0siEy5bldYY6aW4HwwIz9iPB0l64wLuTptbY2llyIrexYbxDT9VMbW6R6uNzRyYc7A==
X-Received: by 2002:a17:902:9046:b029:12c:b5b7:e443 with SMTP id w6-20020a1709029046b029012cb5b7e443mr9392386plz.31.1627999187028;
        Tue, 03 Aug 2021 06:59:47 -0700 (PDT)
Received: from horizon.localdomain ([177.220.172.78])
        by smtp.gmail.com with ESMTPSA id p8sm6569987pfw.35.2021.08.03.06.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 06:59:46 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id DCBA8C08C9; Tue,  3 Aug 2021 10:59:43 -0300 (-03)
Date:   Tue, 3 Aug 2021 10:59:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net] sctp: move the active_key update after sh_keys is
 added
Message-ID: <YQlLz90u6p0yQa4y@horizon.localdomain>
References: <514d9b43054a4dc752b7d575700ad87ae0db5f0c.1627799131.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514d9b43054a4dc752b7d575700ad87ae0db5f0c.1627799131.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 01, 2021 at 02:25:31AM -0400, Xin Long wrote:
> In commit 58acd1009226 ("sctp: update active_key for asoc when old key is
> being replaced"), sctp_auth_asoc_init_active_key() is called to update
> the active_key right after the old key is deleted and before the new key
> is added, and it caused that the active_key could be found with the key_id.

I know it's late, but anyway:
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
