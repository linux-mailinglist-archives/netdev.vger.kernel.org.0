Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BD53B8760
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhF3RIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhF3RIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:08:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB516C061756;
        Wed, 30 Jun 2021 10:06:09 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e20so2978899pgg.0;
        Wed, 30 Jun 2021 10:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RIkOU+NWLSWpNBFQ1H5wMlS7DL2Bt3iFPD7egaJeDt8=;
        b=DGHGmCE980bstdixgjgKaHbl7bG8c4iAUDjD6JTYFL56cVcj5PKdFoJ4JFEnMN8qZS
         YdZ7Hko602FBUdLwxOuoPn42Ur8w2H5NQCJyrrWynGsivxETKQjxCu0RiMP1Xj/zue95
         dJJ3pvQKWZzDHhL9GS6HfvOFKsGPbGv8ddjjTbKMH/qTKH/b9WvCBDlX8irMh00tLT0Z
         A7QW/ijLAJjbWeP3xVTo9MfIOvM6ONcxvogJNDuG3wTBjZDeSBC6sl+Jywb4wwxOkkEq
         fw8NNLNo7rkp64u532CUIO+iBE84lMPFVeQn3xDAFFc7mRyqZ7eNcMAeWK/pbQ1OLvjt
         Ae2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RIkOU+NWLSWpNBFQ1H5wMlS7DL2Bt3iFPD7egaJeDt8=;
        b=GDzRmdOSB1fhsasMhgsPx+jX9lYaYl1h+AuvQt2i9+f8eVaQl7FFZWy1YObE8/mvw5
         NX0e3s+YE9G2QVkdLTz+78tJ7cToqs7CB2TtodtAsDxsei/mQFgwPcarldylvhAaCCZt
         SKnOW9u1EYEyvNQVHQnOq3TPXOnhnstdgXpnswNH5DICxHavL2hnSIQdCyIIgXocK/K+
         +8Aw8tMXhO9y+n2qTl2V11U1ANFerlEsPeWSiWs8/+BNV8Nioak67SeAijHz00HuMifm
         q80hI3Ypm32CZevr23wJn2AySJvm5ibvyzrEoVA+F0CbwCwqOPcpU3m3qi5p/l7nJzzr
         eR6w==
X-Gm-Message-State: AOAM533zO0fX/hEMRWpPqOIdAVi9tA5lj2ferdJ/jsa6LPHfP7yg+MDr
        QY0ELf/QADF1IMPJNruviHBJ76Q9PcA=
X-Google-Smtp-Source: ABdhPJyuM1SifcD8dUWkjLmA831F4Aci5oSypAe5bSz7smORhbFC2pEpRXBLLlKUbQ6ujhLRmQbrRA==
X-Received: by 2002:a63:e948:: with SMTP id q8mr35470710pgj.52.1625072769316;
        Wed, 30 Jun 2021 10:06:09 -0700 (PDT)
Received: from horizon.localdomain ([177.220.174.161])
        by smtp.gmail.com with ESMTPSA id u23sm25897026pgk.38.2021.06.30.10.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 10:06:08 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 4690CC6362; Wed, 30 Jun 2021 14:06:06 -0300 (-03)
Date:   Wed, 30 Jun 2021 14:06:06 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: check pl.raise_count separately from its
 increment
Message-ID: <YNykfoyteRsVvCHn@horizon.localdomain>
References: <727028cb5f9354809a397cf83d72e71b4c97ab85.1625023836.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <727028cb5f9354809a397cf83d72e71b4c97ab85.1625023836.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 11:30:36PM -0400, Xin Long wrote:
> As Marcelo's suggestion this will make code more clear to read.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
