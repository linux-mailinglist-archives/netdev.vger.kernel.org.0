Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F1328511
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfEWRjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:39:35 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43605 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfEWRjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:39:35 -0400
Received: by mail-qk1-f195.google.com with SMTP id z6so4294678qkl.10
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SwBcBJ1JdKjPfMSahtjNaMXPeRzrxoV9MYxtIaEgdMM=;
        b=oTVMqjNKDFY21eUWWUN8MhAa5T/30LWts97BBx0YdIEp/BxAOFqiS/oXKmo5wJVzhH
         xc7N0OIphYohfk94PyO2KMjPKuWdMb9Bn5VRTyCUZpkOCnDHZDeCbCGdWT8+fajWqhJ8
         B3wnU/cQRo5uXrrvXkdyBj1Hrw/onIBn+eR7hKoqQbM8dbTBk9jH7gsJH/Y0h3Y5g5Q0
         UZ4eLRXOOffILItPgwoMm9Ug5J7ZFJY+r/XBeLJrIbGTrlhnq4yXdBYg1fFKh0qlztV+
         4Ek8Ss7hQ1ZSqztUt/1+Yq+8otiyaWHh2d1hzIutFOJr4C4MZylo2V0stwDwUpanJpY/
         FtCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SwBcBJ1JdKjPfMSahtjNaMXPeRzrxoV9MYxtIaEgdMM=;
        b=jjpJ77hIQ/fOiamIxhPcnYqtX4nnH8WP2BViPLodnY0BsceVEOCx685z6liEmdfvZe
         5hJDKLU0GYiEtKjUYQYxJj7608aKhg22+8cSV6OlY/cDVUfcKaz19wBgfxyLf6USRe9Y
         naFjEWhm2OFsUA5qIsnTMCRowhQbcJkETuEMiysEc47IzNDQaAViEBP7QFAbSXx3i2d6
         f1IkGzk7LJAPspKRa3jrGWMkg3Ya2XqHDeUozevuqt0PAnNw0j8MuffCjssvwrf16zl7
         1gaWs2UPtFrR+wrTtWbbRkwyyuXQjGOJdBVBHlKpBd1ZoS7DvJyiqHlGbKZTx9XyTz4K
         FOSg==
X-Gm-Message-State: APjAAAX9+1zf7Dv/USG/4egMVIFlkpjycXprq9bsXvDubDXGl56C/9bN
        WeYGg34hIDTDg2qUUOLFxkk6uQ==
X-Google-Smtp-Source: APXvYqx/mh4RmUB//ciIOt77mpGMAmKDSF7tcTL78BR0uZauAu0UiDttmnF8was2dT+RBB+VvDVMwg==
X-Received: by 2002:ae9:c21a:: with SMTP id j26mr54117829qkg.310.1558633174594;
        Thu, 23 May 2019 10:39:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j10sm12062923qth.8.2019.05.23.10.39.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 10:39:34 -0700 (PDT)
Date:   Thu, 23 May 2019 10:39:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org
Subject: Re: [patch net-next 4/7] devlink: allow driver to update progress
 of flash update
Message-ID: <20190523103929.3dd7cccd@cakuba.netronome.com>
In-Reply-To: <20190523094510.2317-5-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
        <20190523094510.2317-5-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 11:45:07 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Introduce a function to be called from drivers during flash. It sends
> notification to userspace about flash update progress.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Very cool!
