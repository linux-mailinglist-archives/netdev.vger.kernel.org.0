Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D131C104FE1
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUKCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:02:03 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57699 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726014AbfKUKCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574330521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XEzzNkobngto7A7JkTiA2JRstWm/Qwf1aRo6Iv3/3m8=;
        b=EchkKaqhY9VXE48F7d0sXw71wwBxAGvamgpaxJqm47pT3/rV9EaY9U6Wh6XtgyB1ax8o0L
        PyjYhbUb3xtvu4QIVgOTdm6fj6OpBtyNRbsARmgc1ZK4OAjxyeaSzhaUTg/muwbZ1nT83F
        XN4ENy6FWgJOTAm8yu4hP/SIPIoN6mg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-lZLHbHvvOqKhDQJFiWeEYg-1; Thu, 21 Nov 2019 05:02:00 -0500
Received: by mail-wr1-f71.google.com with SMTP id e3so1769337wrs.17
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:02:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tFqAKgUAsSLJXhwvvIOsI4T22gRsWSmbmVmEZ/F0Ht4=;
        b=oGEVNRjm0/XBP+KtFIqDhehOvAkuC/GpvvKNExR/zjyTFXeOEl8dJUH9giql8bFbD4
         xhy+Yp1a6JBssMC6xBkwy+Ka643alLmgBrtS5ldMydfpLYTFGYzLBLAt3z+jfAMdQxAH
         BoFETIhboTPGoYB9dPgQz9QrXuBgqDetKEDzgl2/8QALCEuOrYLiXXojNlK2ydnLOz3G
         YG7jsolHSO1prdlCmo14/KGa2N/sxyK+DqXSE+wXB9909L+P6HyQAUn4RZwyHWvbb4J3
         u+S7U3OcPY+ulwbT1EwAqgosdWCVJDRHRqBUrO6rvHJvoaWJ7bV9KVQhYaBw7PABK1Qr
         pIrg==
X-Gm-Message-State: APjAAAUr6ylXVu1Gn1RVauPm8tgRlBzzc8fgwAMGgnhJnlMn3sza24kc
        GpPbcx9KetE4wwp+QOxATYPAJuUxYj583wVHqCAXolHYFEVC1YE1Tje6B+d0nKnp/u0Z1RE9tKb
        7ivOQ43CDj7a+4WbR
X-Received: by 2002:adf:db8e:: with SMTP id u14mr274456wri.274.1574330519204;
        Thu, 21 Nov 2019 02:01:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqxy6brRF1ev/m1DKBfFjA6HTGnTBIhroRW1ilhIuPxww1/cdIQc+e2rt6PwX9NqSCpO1cJSPg==
X-Received: by 2002:adf:db8e:: with SMTP id u14mr274435wri.274.1574330519006;
        Thu, 21 Nov 2019 02:01:59 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id f188sm2272358wmf.3.2019.11.21.02.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 02:01:58 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:01:56 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 5/6] vsock: use local transport when it is loaded
Message-ID: <20191121100156.v4ehwmstlhujrviv@steredhat>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-6-sgarzare@redhat.com>
 <20191121094614.GC439743@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <20191121094614.GC439743@stefanha-x1.localdomain>
X-MC-Unique: lZLHbHvvOqKhDQJFiWeEYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 09:46:14AM +0000, Stefan Hajnoczi wrote:
> On Tue, Nov 19, 2019 at 12:01:20PM +0100, Stefano Garzarella wrote:
> > @@ -420,9 +436,10 @@ int vsock_assign_transport(struct vsock_sock *vsk,=
 struct vsock_sock *psk)
> >  =09=09new_transport =3D transport_dgram;
> >  =09=09break;
> >  =09case SOCK_STREAM:
> > -=09=09if (remote_cid <=3D VMADDR_CID_HOST ||
> > -=09=09    (transport_g2h &&
> > -=09=09     remote_cid =3D=3D transport_g2h->get_local_cid()))
> > +=09=09if (vsock_use_local_transport(remote_cid))
> > +=09=09=09new_transport =3D transport_local;
> > +=09=09else if (remote_cid =3D=3D VMADDR_CID_HOST ||
> > +=09=09=09 remote_cid =3D=3D VMADDR_CID_HYPERVISOR)
> >  =09=09=09new_transport =3D transport_g2h;
> >  =09=09else
> >  =09=09=09new_transport =3D transport_h2g;
>=20
> We used to send VMADDR_CID_RESERVED to the host.  Now we send
> VMADDR_CID_RESERVED (LOCAL) to the guest when there is no
> transport_local loaded?
>=20
> If this is correct, is there a justification for this change?  It seems
> safest to retain existing behavior.

You're right, I'll revert this change in v2.

Thanks,
Stefano

