Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F841B30A2
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgDUTrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDUTrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:47:41 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A366C0610D6
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:47:40 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id u13so17978164wrp.3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3fl+lvLy/eECmlgZWfYYWnfhkwqQGBLTrseAA2rmeCA=;
        b=ewRnXuwLIo4LCFt/bUB2DhfOUGO+gehpOMxmhHjijhKBBUU0LsEGKij2pnaZE72wll
         HZilhtsV6wtqgKTgq6ML4n+tFg4l0bHOG7lz66+ne4aLeqfZCUrUxvXvjclqlqvJiYTu
         6B/000GB6j6OrYXARTEiGQJI7j3lnfbKSK4xlu/nF1SyzOV+kTQLCxSjU5oTJa5Hauaf
         tIp7rX0Bez+s7tldBHxq0RJ4EG7bKuwoaxmhEORoDzsa2QAHo8sohXa+sD65AfubLAA8
         wi20g/4JNbxwkzkQfgXhqO4/Wwn3jyMMcowz3XyEaMI0KZIrA2BQpsIxTcB8QodVIrVW
         20ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3fl+lvLy/eECmlgZWfYYWnfhkwqQGBLTrseAA2rmeCA=;
        b=QfqzJPWWDP9OxiA/eiyEFEhGj97Ur5mTW8ferYmiEfliuEil6SMLLY02ht4shaAihR
         8gtbY3Uyt59L6BKV+3xKJ+CM+TupLExhctEU07GPkzpNcEtCOwMFuIExb/PFTtG1BEr8
         nYTXmpCAoONbZjMB/j5n1DHKe2qme9JuCz2XD/PxqOsyNxUtUiLbFWdWWHtUbMd3hAsi
         NIgnLqUQwJhIglf6RlQqgmzA33QfGDpDhV1rJ/rIW4mW85MGNxizgw0ssFEWZtU+2MzD
         Ejj2abhxPSBAyloX/ZwJNfJMSHb+JCBY9LN3guk8rVIZKIk/9uTGHlg3kKQMcTSOwQwJ
         3yCw==
X-Gm-Message-State: AGi0PuYHPTG63E2g43pJuvxCSNHacnfcVmg2+Ej+k97Ha2BFTWb6iZgg
        mNGW+jGPrzkBNnLRpjdFjKkI6g==
X-Google-Smtp-Source: APiQypJI3dyTLtlGmPWjEbq/MzKWyTGAmOjZYNJQy0aKf68LlBT1OMLDqi3nms/L0XeumvizZyZ4vg==
X-Received: by 2002:a5d:4443:: with SMTP id x3mr25015672wrr.162.1587498458295;
        Tue, 21 Apr 2020 12:47:38 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a1sm5051893wrn.80.2020.04.21.12.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 12:47:37 -0700 (PDT)
Date:   Tue, 21 Apr 2020 21:47:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V3 mlx5-next 08/15] bonding: Add array of all salves
Message-ID: <20200421194736.GG6581@nanopsycho.orion>
References: <20200421102844.23640-1-maorg@mellanox.com>
 <20200421102844.23640-9-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421102844.23640-9-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 21, 2020 at 12:28:37PM CEST, maorg@mellanox.com wrote:
>Keep all slaves in array so it could be used to get the xmit slave
>assume all the slaves are active.
>The logic to add slave to the array is like the usable slaves, except
>that we also add slaves that currently can't transmit - not up or active.
>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
