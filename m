Return-Path: <netdev+bounces-6523-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1EA1716C89
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28C1C1C20D2A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92F32D26D;
	Tue, 30 May 2023 18:31:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89092D272
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:31:14 +0000 (UTC)
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9564DA7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:31:12 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-528cdc9576cso3048413a12.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685471472; x=1688063472;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xv2saavm9IMAX2Nk8UODmbmhuFWaZtIu1VSRiBkQPmQ=;
        b=gL0DbnGrSZAzQhibIgphnQQLlTa7e2Nab2d0Q9yirrdrs4ocP3/JDMqMiDv9EzmWUL
         oRagQhUSKdagfefXOml6NpZ8qNYnoKAsQclFPjs1qiuq1rIOBQMYd45WHahe89LKnzrj
         QeMkMHsG8RuZeQKzZCMKBBB+STl5xflr6t1BKLf/x1mYpnZx0KEJ8XNYyJNPSHy3atAr
         9HBx0wyzodYhUd186boxK2+pyGtnBIEnhzQ4MqDcJanz9OoRfTT+MpQobase1jeuxyKE
         nddz7R2JhoLymAAERsIwsSE9pMTiqg/RqrH0d8JnL2JEbKcmqUH9i1/9HFRuyEpdIkc3
         MT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685471472; x=1688063472;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xv2saavm9IMAX2Nk8UODmbmhuFWaZtIu1VSRiBkQPmQ=;
        b=bAzQv+W29CeIK/bA88Myj8MLmQLjmjRBBIXa1v2w/Rw8m4AJDVA/hrXuUO04rYWZHR
         +tsL6XOR/bMZ4WFnXfJ/D8VrDGAjU3PrHzKqAtbMohQBMs+2TBAtnyqIfDbFFOiARq/E
         +nT0hkQQbrzdDcSrg2hTZCY31sPF1NWdJOq2ZpQYbMyHVR96c5Tbu+pHj2M/9uuytWMw
         IKYGv9TUwaB93LocMs/KoU2XWElE6UDcDrZUbLx1WxE0WCEjXeLYAjgvu2kVTzH8neWq
         O6+vUZeEgS7y0Q+pwJUpxkX7MTVdT857ZY2xio45j8ATOFXYkzf/hSSXTtptpHrQjpES
         +MtA==
X-Gm-Message-State: AC+VfDyLpN+nvaoiWiKNfnwaTKSdWepHXpImLpz4n/4fOzJidEejfbDc
	sV3iw9wrI6ZWSDY0r8ZYaBA=
X-Google-Smtp-Source: ACHHUZ5PPkYYVhoEP+etOQ/e/yOyxPrat18Ez6HS87svm++QZZEHqA3jQfDKlE153fmLsoFlHAkFrQ==
X-Received: by 2002:a17:903:2349:b0:1ae:3036:b594 with SMTP id c9-20020a170903234900b001ae3036b594mr3523822plh.49.1685471471854;
        Tue, 30 May 2023 11:31:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o8-20020a1709026b0800b001ac94b33ab1sm10527310plk.304.2023.05.30.11.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:31:11 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------5SClqBBg6FfeGLUjPzxeWESZ"
Message-ID: <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
Date: Tue, 30 May 2023 11:31:04 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
 Russell King <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a multi-part message in MIME format.
--------------5SClqBBg6FfeGLUjPzxeWESZ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew, Russell,

On 3/30/23 17:54, Andrew Lunn wrote:
> Most MAC drivers get EEE wrong. The API to the PHY is not very
> obvious, which is probably why. Rework the API, pushing most of the
> EEE handling into phylib core, leaving the MAC drivers to just
> enable/disable support for EEE in there change_link call back, or
> phylink mac_link_up callback.
> 
> MAC drivers are now expect to indicate to phylib/phylink if they
> support EEE. If not, no EEE link modes are advertised. If the MAC does
> support EEE, on phy_start()/phylink_start() EEE advertisement is
> configured.

Thanks for doing this work, because it really is a happy mess out there. 
A few questions as I have been using mvneta as the reference for fixing 
GENET and its shortcomings.

In your new patches the decision to enable EEE is purely based upon the 
eee_active boolean and not eee_enabled && tx_lpi_enabled unlike what 
mvneta useed to do.

Russell, is there an use case for having eee_enabled while not having 
tx_lpi_enabled?

With the candidate patch attached, I have the following behavior on boot 
with no specific ethtool operation:

# ethtool --show-eee eth0
EEE Settings for eth0:
         EEE status: enabled - active
         Tx LPI: disabled
         Supported EEE link modes:  100baseT/Full
                                    1000baseT/Full
         Advertised EEE link modes:  100baseT/Full
                                     1000baseT/Full
         Link partner advertised EEE link modes:  100baseT/Full
                                                  1000baseT/Full
#

however EEE is not *really* enabled at the hardware level unless I do 
another:

# ethtool --set-eee eth0 tx-lpi on
# ethtool --show-eee eth0
EEE Settings for eth0:
         EEE status: enabled - active
         Tx LPI: 34 (us)
         Supported EEE link modes:  100baseT/Full
                                    1000baseT/Full
         Advertised EEE link modes:  100baseT/Full
                                     1000baseT/Full
         Link partner advertised EEE link modes:  100baseT/Full
                                                  1000baseT/Full

We have a global EEE enable bit which is described as "If set, the TX 
LPI policy control engine is enabled and the MAC inserts LPI_idle codes 
if the link is idle", so it would seem to me that we should require 
users to set both "eee on" and "tx-lpi on" in their ethtool command, but 
then unless we intentionally override tx_lpi_enabled in the driver upon 
probe, there will be any automagical configuration happening, and no 
power savings being realized.

Do you have any recommendations on what drivers should do? As you could 
see from the need of this patch series, we already all created our own 
little schisms of the cargo cult.

Thanks!
-- 
Florian

--------------5SClqBBg6FfeGLUjPzxeWESZ
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-bcmgenet-Fix-EEE-implementation.patch"
Content-Disposition: attachment;
 filename="0001-net-bcmgenet-Fix-EEE-implementation.patch"
Content-Transfer-Encoding: base64

RnJvbSBmZjVlZDQ4YzAwOGUwNTJhMzAwNWU4MTAwMTc0ODA1ODA0NWQwOWQyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxmbG9yaWFuLmZhaW5l
bGxpQGJyb2FkY29tLmNvbT4KRGF0ZTogVHVlLCAzMCBNYXkgMjAyMyAxMTowNzo1NyAtMDcw
MApTdWJqZWN0OiBbUEFUQ0hdIG5ldDogYmNtZ2VuZXQ6IEZpeCBFRUUgaW1wbGVtZW50YXRp
b24KCldlIGhhZCBhIG51bWJlciBvZiBzaG9ydCBjb21pbmdzOgoKLSBFRUUgbXVzdCBiZSBy
ZS1ldmFsdWF0ZWQgd2hlbmV2ZXIgdGhlIHN0YXRlIG1hY2hpbmUgZGV0ZWN0cyBhIGxpbmsK
Y2hhbmdlIGFzIHdpZ2h0IGJlIHN3aXRjaGluZyBmcm9tIGEgbGluayBwYXJ0bmVyIHdpdGgg
RUVFCmVuYWJsZWQvZGlzYWJsZWQKCi0gV2UgZG8gbm90IG5lZWQgdG8gZm9yY2libHkgZW5h
YmxlIEVFRSB1cG9uIHN5c3RlbSByZXN1bWUsIGFzIHRoZSBQSFkKc3RhdGUgbWFjaGluZSB3
aWxsIHRyaWdnZXIgYSBsaW5rIGV2ZW50IHRoYXQgd2lsbCBkbyB0aGF0LCB0b28KCi0gRUVF
IHNoYWxsIGJlIGVuYWJsZWQgaWYgYm90aCBlZWVfYWN0aXZlIGFuZCB0eF9scGlfZW5hYmxl
ZCBhcmUgc2V0CgpyZWZzICNTV0xJTlVYLTY2NTUKClNpZ25lZC1vZmYtYnk6IEZsb3JpYW4g
RmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPgpDaGFuZ2UtSWQ6IEll
OWMzZmY2MzQ1OGYwOGYwMGIwZDE5NjI1MjA1Mzk2YzdhM2Q1MzA2Ci0tLQogZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtZ2VuZXQuYyB8IDE4ICsrKysrKy0tLS0t
LS0tLS0tLQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtZ2VuZXQu
aCB8ICAyICsrCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21taWku
YyAgIHwgIDQgKysrKwogMyBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNv
bS9nZW5ldC9iY21nZW5ldC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2Vu
ZXQvYmNtZ2VuZXQuYwppbmRleCA5ZDc3MGI3NmY5YmIuLmYzMTkzMDIxNTA5OSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtZ2VuZXQuYwor
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5jCkBA
IC0xMjkxLDcgKzEyOTEsNyBAQCBzdGF0aWMgdm9pZCBiY21nZW5ldF9nZXRfZXRodG9vbF9z
dGF0cyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LAogCX0KIH0KIAotc3RhdGljIHZvaWQgYmNt
Z2VuZXRfZWVlX2VuYWJsZV9zZXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgYm9vbCBlbmFi
bGUpCit2b2lkIGJjbWdlbmV0X2VlZV9lbmFibGVfc2V0KHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsIGJvb2wgZW5hYmxlKQogewogCXN0cnVjdCBiY21nZW5ldF9wcml2ICpwcml2ID0gbmV0
ZGV2X3ByaXYoZGV2KTsKIAl1MzIgb2ZmID0gcHJpdi0+aHdfcGFyYW1zLT50YnVmX29mZnNl
dCArIFRCVUZfRU5FUkdZX0NUUkw7CkBAIC0xMzQ3LDYgKzEzNDcsNyBAQCBzdGF0aWMgaW50
IGJjbWdlbmV0X2dldF9lZWUoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGV0aHRv
b2xfZWVlICplKQogCiAJZS0+ZWVlX2VuYWJsZWQgPSBwLT5lZWVfZW5hYmxlZDsKIAllLT5l
ZWVfYWN0aXZlID0gcC0+ZWVlX2FjdGl2ZTsKKwllLT50eF9scGlfZW5hYmxlZCA9IHAtPnR4
X2xwaV9lbmFibGVkOwogCWUtPnR4X2xwaV90aW1lciA9IGJjbWdlbmV0X3VtYWNfcmVhZGwo
cHJpdiwgVU1BQ19FRUVfTFBJX1RJTUVSKTsKIAogCXJldHVybiBwaHlfZXRodG9vbF9nZXRf
ZWVlKGRldi0+cGh5ZGV2LCBlKTsKQEAgLTEzNTYsNyArMTM1Nyw2IEBAIHN0YXRpYyBpbnQg
YmNtZ2VuZXRfc2V0X2VlZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgZXRodG9v
bF9lZWUgKmUpCiB7CiAJc3RydWN0IGJjbWdlbmV0X3ByaXYgKnByaXYgPSBuZXRkZXZfcHJp
dihkZXYpOwogCXN0cnVjdCBldGh0b29sX2VlZSAqcCA9ICZwcml2LT5lZWU7Ci0JaW50IHJl
dCA9IDA7CiAKIAlpZiAoR0VORVRfSVNfVjEocHJpdikpCiAJCXJldHVybiAtRU9QTk9UU1VQ
UDsKQEAgLTEzNjksMTQgKzEzNjksMTEgQEAgc3RhdGljIGludCBiY21nZW5ldF9zZXRfZWVl
KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCBldGh0b29sX2VlZSAqZSkKIAlpZiAo
IXAtPmVlZV9lbmFibGVkKSB7CiAJCWJjbWdlbmV0X2VlZV9lbmFibGVfc2V0KGRldiwgZmFs
c2UpOwogCX0gZWxzZSB7Ci0JCXJldCA9IHBoeV9pbml0X2VlZShkZXYtPnBoeWRldiwgMCk7
Ci0JCWlmIChyZXQpIHsKLQkJCW5ldGlmX2Vycihwcml2LCBodywgZGV2LCAiRUVFIGluaXRp
YWxpemF0aW9uIGZhaWxlZFxuIik7Ci0JCQlyZXR1cm4gcmV0OwotCQl9Ci0KKwkJcC0+ZWVl
X2FjdGl2ZSA9IHBoeV9pbml0X2VlZShkZXYtPnBoeWRldiwgMCkgPj0gMDsKKwkJcC0+dHhf
bHBpX2VuYWJsZWQgPSBlLT50eF9scGlfZW5hYmxlZDsKIAkJYmNtZ2VuZXRfdW1hY193cml0
ZWwocHJpdiwgZS0+dHhfbHBpX3RpbWVyLCBVTUFDX0VFRV9MUElfVElNRVIpOwotCQliY21n
ZW5ldF9lZWVfZW5hYmxlX3NldChkZXYsIHRydWUpOworCQliY21nZW5ldF9lZWVfZW5hYmxl
X3NldChkZXYsCisJCQkJCXAtPmVlZV9hY3RpdmUgJiYgcC0+dHhfbHBpX2VuYWJsZWQpOwog
CX0KIAogCXJldHVybiBwaHlfZXRodG9vbF9zZXRfZWVlKGRldi0+cGh5ZGV2LCBlKTsKQEAg
LTQzMTAsOSArNDMwNyw2IEBAIHN0YXRpYyBpbnQgYmNtZ2VuZXRfcmVzdW1lKHN0cnVjdCBk
ZXZpY2UgKmQpCiAJaWYgKCFkZXZpY2VfbWF5X3dha2V1cChkKSkKIAkJcGh5X3Jlc3VtZShk
ZXYtPnBoeWRldik7CiAKLQlpZiAocHJpdi0+ZWVlLmVlZV9lbmFibGVkKQotCQliY21nZW5l
dF9lZWVfZW5hYmxlX3NldChkZXYsIHRydWUpOwotCiAJYmNtZ2VuZXRfbmV0aWZfc3RhcnQo
ZGV2KTsKIAogCW5ldGlmX2RldmljZV9hdHRhY2goZGV2KTsKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2dlbmV0L2JjbWdlbmV0LmggYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5oCmluZGV4IDQ3YjgzMjZjMmYz
OS4uY2U2YjlmMjlmM2Q4IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9h
ZGNvbS9nZW5ldC9iY21nZW5ldC5oCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2Fk
Y29tL2dlbmV0L2JjbWdlbmV0LmgKQEAgLTc1OCw0ICs3NTgsNiBAQCBpbnQgYmNtZ2VuZXRf
d29sX3Bvd2VyX2Rvd25fY2ZnKHN0cnVjdCBiY21nZW5ldF9wcml2ICpwcml2LAogdm9pZCBi
Y21nZW5ldF93b2xfcG93ZXJfdXBfY2ZnKHN0cnVjdCBiY21nZW5ldF9wcml2ICpwcml2LAog
CQkJICAgICAgIGVudW0gYmNtZ2VuZXRfcG93ZXJfbW9kZSBtb2RlKTsKIAordm9pZCBiY21n
ZW5ldF9lZWVfZW5hYmxlX3NldChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBib29sIGVuYWJs
ZSk7CisKICNlbmRpZiAvKiBfX0JDTUdFTkVUX0hfXyAqLwpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtbWlpLmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21taWkuYwppbmRleCA2MTNlNDAyMDI5MTUuLjkw
Y2RkNTRmOGE4ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20v
Z2VuZXQvYmNtbWlpLmMKKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2Vu
ZXQvYmNtbWlpLmMKQEAgLTEwOCw2ICsxMDgsMTAgQEAgc3RhdGljIHZvaWQgYmNtZ2VuZXRf
bWFjX2NvbmZpZyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCQlyZWcgfD0gQ01EX1RYX0VO
IHwgQ01EX1JYX0VOOwogCX0KIAliY21nZW5ldF91bWFjX3dyaXRlbChwcml2LCByZWcsIFVN
QUNfQ01EKTsKKworCXByaXYtPmVlZS5lZWVfYWN0aXZlID0gcGh5X2luaXRfZWVlKHBoeWRl
diwgMCkgPj0gMDsKKwliY21nZW5ldF9lZWVfZW5hYmxlX3NldChkZXYsIHByaXYtPmVlZS5l
ZWVfYWN0aXZlICYmCisJCQkJcHJpdi0+ZWVlLnR4X2xwaV9lbmFibGVkKTsKIH0KIAogLyog
c2V0dXAgbmV0ZGV2IGxpbmsgc3RhdGUgd2hlbiBQSFkgbGluayBzdGF0dXMgY2hhbmdlIGFu
ZAotLSAKMi4yNS4xCgo=

--------------5SClqBBg6FfeGLUjPzxeWESZ--

