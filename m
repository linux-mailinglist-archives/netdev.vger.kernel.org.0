Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32CA3BAE1
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbfFJRYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:24:47 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:38848 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbfFJRYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:24:44 -0400
Received: by mail-vs1-f68.google.com with SMTP id b10so5915469vsp.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 10:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ql54rhkLM/xOU5juI4JV8nZ7IEe8V/7olj9J6CUOCpI=;
        b=AOC/EVBW5NUBhSJ4U+I8rgjxNKHWQhLg/O+/vCrL9CPkGcYvXKxEo0GhfL2MUZg85m
         oY9wbxOB6WSSmNv/YDsZT/PZb5KLcwBo59CbDD6oqTWIOj3tw8xneom4XurQMhy/1cUL
         Z9FPDdgDt3AicI/EU6IjIUcnTt0KUeHE9WrVs1MHyI9JfhWZmoPbtQgEw8vJQ8k6+urx
         D5jmvKkE9opcUMd+FrUIfd1qTAxOUZvBahXSNyflGIC4h9Y7k+ac/LQwENT1mnALWNAg
         gXZfXc286gB23VRIQwJ57j6igD6dRakanmJG42LPXrp2yZslNo1f44lqEPdqJeqgjL2r
         qHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ql54rhkLM/xOU5juI4JV8nZ7IEe8V/7olj9J6CUOCpI=;
        b=QgvJ4nojl1pKgyxES3laxo4NK3OlpAlZ5bSI1lXoAWVf3bmei4TlaN36+DbZJ/Y3au
         1on6moqAQtLKbSLJ/z5eZA1yycZBTh7F8pDiXoTsc350u0m4Br468TNrucRELURRMoJo
         M4eSrV1o2JK7obmWryUmkTLy9R8lfyPSapR4qpoSormT9U/Mwyj5TmJU6BTT2VnZXRjW
         94IxIfPK066TTHn41ShGbNYR6TM114bJm+zrRkjhdb0bJANJjZTDj9dWqCXHJQbwv/un
         yvY5WzY5bKIENc/3frq8tajwfcUX5c/18paffsNsBmqMD1FO4IeheGKlUY+Q1M49xskW
         98jA==
X-Gm-Message-State: APjAAAVtocUmqZZu39I5zaENs3j1YyX6LbePesOrq0vMjRlCu1cdFxc4
        yoeByzLFIxtpa9W7Vvj8anCvrA==
X-Google-Smtp-Source: APXvYqwEhlM1pgkgub3MdyYQ2Sz8qrl4yKj7CXpsTjQU4LoL0StnEtk6tIyvFu9AqXpSr13KE5z8rQ==
X-Received: by 2002:a67:2704:: with SMTP id n4mr14149667vsn.202.1560187483546;
        Mon, 10 Jun 2019 10:24:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y186sm3410398vkd.56.2019.06.10.10.24.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 10:24:43 -0700 (PDT)
Date:   Mon, 10 Jun 2019 10:24:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v3 3/3] devlink: implement flash status
 monitoring
Message-ID: <20190610102438.69880dcd@cakuba.netronome.com>
In-Reply-To: <08f73e0f-918b-4750-366b-47d7e5ab4422@gmail.com>
References: <20190604134044.2613-1-jiri@resnulli.us>
        <20190604134450.2839-3-jiri@resnulli.us>
        <08f73e0f-918b-4750-366b-47d7e5ab4422@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 11:09:19 -0600, David Ahern wrote:
> On 6/4/19 7:44 AM, Jiri Pirko wrote:
> > diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
> > index 1804463b2321..1021ee8d064c 100644
> > --- a/man/man8/devlink-dev.8
> > +++ b/man/man8/devlink-dev.8
> > @@ -244,6 +244,17 @@ Sets the parameter internal_error_reset of specified devlink device to true.
> >  devlink dev reload pci/0000:01:00.0
> >  .RS 4
> >  Performs hot reload of specified devlink device.
> > +.RE
> > +.PP
> > +devlink dev flash pci/0000:01:00.0 file firmware.bin
> > +.RS 4
> > +Flashes the specified devlink device with provided firmware file name. If the driver supports it, user gets updates about the flash status. For example:
> > +.br
> > +Preparing to flash
> > +.br
> > +Flashing 100%
> > +.br
> > +Flashing done
> >  
> >  .SH SEE ALSO
> >  .BR devlink (8),  
> 
> something is missing here from a user perspective at least:
> 
> root@mlx-2700-05:~# ./devlink dev
> pci/0000:03:00.0
> 
> root@mlx-2700-05:~# ./devlink dev flash pci/0000:03:00.0 file
> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
> devlink answers: No such file or directory
> 
> root@mlx-2700-05:~# ls -l
> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
> -rw-r--r-- 1 cumulus 1001 994184 May 14 22:44
> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
> 
> 
> Why the 'no such file' response when the file exists?

I think the FW loader prepends /lib/firmware to the path (there is a
CONFIG_ for the search paths, and / is usually not on it).  Perhaps try:

./devlink dev flash pci/0000:03:00.0 file mellanox/mlxsw_spectrum-13.2000.1122.mfa2
