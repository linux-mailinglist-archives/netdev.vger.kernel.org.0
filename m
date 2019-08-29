Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BEAA1C43
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 16:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfH2ODB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 10:03:01 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41755 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfH2ODB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 10:03:01 -0400
Received: by mail-qk1-f193.google.com with SMTP id g17so2998830qkk.8
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 07:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=I+IZFgJZawwDJ4LKhbYRBA4XDV0DYxZ4lZr4Aht4zZM=;
        b=To919troFaDNeUAZK6yt7vcu56TCb254xXguDWzgaMbg69mPd+KA4oH+oIGd6GYDdD
         B8Jfb9ftq4YsXwXgUwe4PwV4tUDOcoqcycbrlaCuuk8r5nD+GNH39TUZfPstv9zI+7dx
         gNIxSwbfhfX7yYOC7geH/FqRdNqZNAyTikjiWjNYY4QLGnEYAiYGezOndYwFaKn7Juvb
         1YovnghOtu1prZFAuccnuliQ4TlhKnGaLXImE6VOp/dstbU+qIkZstGchqFNg6rPz/dg
         IvFf8kRoz8Sw0QNAyO01mShF3XWWEzv8FwggeL7F8/n3noAfb5c1BZrr9Jbmytv2xza6
         UCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=I+IZFgJZawwDJ4LKhbYRBA4XDV0DYxZ4lZr4Aht4zZM=;
        b=BM3PAaaXW9xjrwuMotEaMkQiH9stT0gQzhPCONzhA491GXdRLbb1paF5qHC0dQYNqm
         hBzvWGRQA6qLKbDmOWl/nBvFBe3kPc7De+OtSOjRegrkUP9CLxNpzRQARFhbuUIq+KzR
         s+bYF3jjA5KQLHbFqepdYEwvHtZP/gf0K6WRoqaetw1e4MwijqKl1tdyVt9/dKAsZtwJ
         cDKg/w171FBBe/PmBrbDaRPA/lExVOe1kDeGa0QTtmdvQixqUG+vwVLQoP2XNjN8pS2b
         kHYJsE9mS9y0Oi2cbveghweVbXDDxzTAWCvLgkyQwcZfooUmX7aUgpYsNPWTgcNq5Gun
         ob/w==
X-Gm-Message-State: APjAAAUk3d/RM4/3XOn/bGmwWjFzOB9nV3/gPAyTVZx5SaDrP5zQCaZC
        UTxXp7vGTshKL4LjlFf8ap4=
X-Google-Smtp-Source: APXvYqxJsmtJxu+xApRYxsSv+gvIK/ES7R6fUs4LAj+RFEhmxPBzYj41ap6rQ+LDgbrF95K6u6CVrg==
X-Received: by 2002:a37:64c8:: with SMTP id y191mr9390198qkb.210.1567087379360;
        Thu, 29 Aug 2019 07:02:59 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y204sm1453338qka.54.2019.08.29.07.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 07:02:58 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:02:57 -0400
Message-ID: <20190829100257.GB8933@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: tag_8021q: Restore bridge VLANs
 when enabling vlan_filtering
In-Reply-To: <CA+h21hq=VVw0p0OjGaPx2-c4FE1ge-STRVHYZ6P62c-+_xW0nw@mail.gmail.com>
References: <20190825184454.14678-1-olteanv@gmail.com>
 <20190825184454.14678-3-olteanv@gmail.com>
 <CA+h21hq=VVw0p0OjGaPx2-c4FE1ge-STRVHYZ6P62c-+_xW0nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, 29 Aug 2019 14:50:14 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > +static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
> > +{
> > +       struct bridge_vlan_info vinfo;
> > +       struct net_device *slave;
> > +       u16 pvid;
> > +       int err;
> > +
> > +       if (!dsa_is_user_port(ds, port))
> > +               return 0;
> > +
> > +       slave = ds->ports[port].slave;
> > +
> > +       err = br_vlan_get_pvid(slave, &pvid);
> > +       if (err < 0) {
> > +               dev_err(ds->dev, "Couldn't determine bridge PVID\n");
> > +               return err;
> > +       }
> > +
> > +       err = br_vlan_get_info(slave, pvid, &vinfo);
> > +       if (err < 0) {
> > +               dev_err(ds->dev, "Couldn't determine PVID attributes\n");
> > +               return err;
> > +       }
> > +
> > +       return dsa_port_vid_add(&ds->ports[port], pvid, vinfo.flags);
> 
> If the bridge had installed a dsa_8021q VLAN here, I need to use the
> dsa_slave_vid_add logic to restore it. The dsa_8021q flags on the CPU
> port are "ingress tagged", but that may not be the case for the bridge
> VLAN.
> Should I expose dsa_slave_vlan_add in dsa_priv.h, or should I just
> open-code another dsa_port_vid_add for dp->cpu_dp, duplicating a bit
> of code from dsa_slave_vlan_add?

dsa_slave_* functions are the entry points for operations performed on the
net_device structures exposed to userspace. Using them elsewhere seems wrong.

dsa_port_* functions scope any dsa_port structure regardless its type though,
so I'd suggest duplicating a bit of code in tag_8021q.c to implement this
specific use case, until we figure out something nice to factorize.


Thank you,

	Vivien
